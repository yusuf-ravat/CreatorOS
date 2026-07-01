import { Injectable, UnauthorizedException, ConflictException, BadRequestException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import { PrismaClient } from '@prisma/client';
import * as bcrypt from 'bcrypt';
import { v4 as uuidv4 } from 'uuid';

@Injectable()
export class AuthService {
  constructor(
    private prisma: PrismaClient,
    private jwtService: JwtService,
    private configService: ConfigService,
  ) {}

  async register(email: string, password: string, name: string) {
    // Check if user exists
    const existingUser = await this.prisma.user.findUnique({ where: { email } });
    
    if (existingUser) {
      throw new ConflictException('User with this email already exists');
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 12);

    // Create organization for the user
    const organization = await this.prisma.organization.create({
      data: {
        name: `${name}'s Workspace`,
        slug: `org-${uuidv4().slice(0, 8)}`,
      },
    });

    // Create user
    const user = await this.prisma.user.create({
      data: {
        email,
        password: hashedPassword,
        name,
        role: 'OWNER',
        organizationId: organization.id,
      },
      include: {
        organization: true,
      },
    });

    // Create default membership
    await this.prisma.membership.create({
      data: {
        userId: user.id,
        organizationId: organization.id,
        role: 'OWNER',
      },
    });

    const tokens = await this.generateTokens(user);

    return {
      user: this.sanitizeUser(user),
      ...tokens,
    };
  }

  async login(email: string, password: string) {
    const user = await this.prisma.user.findUnique({
      where: { email },
      include: { organization: true },
    });

    if (!user || !user.password) {
      throw new UnauthorizedException('Invalid credentials');
    }

    const isPasswordValid = await bcrypt.compare(password, user.password);

    if (!isPasswordValid) {
      throw new UnauthorizedException('Invalid credentials');
    }

    const tokens = await this.generateTokens(user);

    return {
      user: this.sanitizeUser(user),
      ...tokens,
    };
  }

  async loginWithGoogle(googleId: string, email: string, name: string, picture?: string) {
    let user = await this.prisma.user.findUnique({
      where: { googleId },
      include: { organization: true },
    });

    if (!user) {
      // Check if user exists with this email
      user = await this.prisma.user.findUnique({
        where: { email },
        include: { organization: true },
      });

      if (user) {
        // Link Google account to existing user
        user = await this.prisma.user.update({
          where: { id: user.id },
          data: { googleId },
          include: { organization: true },
        });
      } else {
        // Create new user
        const organization = await this.prisma.organization.create({
          data: {
            name: `${name}'s Workspace`,
            slug: `org-${uuidv4().slice(0, 8)}`,
          },
        });

        user = await this.prisma.user.create({
          data: {
            googleId,
            email,
            name,
            avatar: picture,
            role: 'OWNER',
            organizationId: organization.id,
            emailVerified: new Date(),
          },
          include: { organization: true },
        });

        await this.prisma.membership.create({
          data: {
            userId: user.id,
            organizationId: organization.id,
            role: 'OWNER',
          },
        });
      }
    }

    const tokens = await this.generateTokens(user);

    return {
      user: this.sanitizeUser(user),
      ...tokens,
    };
  }

  async refreshToken(refreshToken: string) {
    try {
      const payload = await this.jwtService.verifyAsync(refreshToken, {
        secret: this.configService.get('REFRESH_TOKEN_SECRET'),
      });

      const user = await this.prisma.user.findUnique({
        where: { id: payload.sub },
        include: { organization: true },
      });

      if (!user) {
        throw new UnauthorizedException('User not found');
      }

      const tokens = await this.generateTokens(user);

      return tokens;
    } catch (err) {
      throw new UnauthorizedException('Invalid refresh token');
    }
  }

  async logout(userId: string) {
    // In production, you might want to blacklist the token or clear sessions
    await this.prisma.session.deleteMany({
      where: { userId },
    });
    
    return { message: 'Logged out successfully' };
  }

  private async generateTokens(user: any) {
    const [accessToken, refreshToken] = await Promise.all([
      this.jwtService.signAsync(
        {
          sub: user.id,
          email: user.email,
          roles: [user.role],
          organizationId: user.organizationId,
        },
        {
          secret: this.configService.get('JWT_SECRET'),
          expiresIn: this.configService.get('JWT_EXPIRES_IN', '15m'),
        },
      ),
      this.jwtService.signAsync(
        { sub: user.id },
        {
          secret: this.configService.get('REFRESH_TOKEN_SECRET'),
          expiresIn: this.configService.get('REFRESH_TOKEN_EXPIRES_IN', '7d'),
        },
      ),
    ]);

    return { accessToken, refreshToken };
  }

  private sanitizeUser(user: any) {
    const { password, googleId, ...sanitized } = user;
    return sanitized;
  }
}
