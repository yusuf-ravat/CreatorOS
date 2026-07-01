import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';

@Injectable()
export class UsersService {
  constructor(private prisma: PrismaClient) {}

  async findAll(organizationId: string, page = 1, limit = 10, search?: string) {
    const skip = (page - 1) * limit;
    
    const where: any = {
      memberships: {
        some: {
          organizationId,
        },
      },
    };

    if (search) {
      where.OR = [
        { name: { contains: search, mode: 'insensitive' } },
        { email: { contains: search, mode: 'insensitive' } },
      ];
    }

    const [users, total] = await Promise.all([
      this.prisma.user.findMany({
        where,
        skip,
        take: limit,
        include: {
          memberships: {
            where: { organizationId },
            include: { organization: true },
          },
        },
        orderBy: { createdAt: 'desc' },
      }),
      this.prisma.user.count({ where }),
    ]);

    return {
      data: users.map((u) => this.sanitizeUser(u)),
      meta: {
        total,
        page,
        limit,
        totalPages: Math.ceil(total / limit),
      },
    };
  }

  async findOne(id: string, organizationId: string) {
    const user = await this.prisma.user.findFirst({
      where: {
        id,
        memberships: {
          some: { organizationId },
        },
      },
      include: {
        memberships: {
          include: { organization: true },
        },
      },
    });

    if (!user) {
      throw new NotFoundException('User not found');
    }

    return this.sanitizeUser(user);
  }

  async update(id: string, userId: string, data: any) {
    // Only allow users to update their own profile unless they're admin
    if (id !== userId) {
      const currentUser = await this.prisma.user.findUnique({
        where: { id: userId },
      });
      
      if (currentUser?.role !== 'OWNER' && currentUser?.role !== 'ADMIN') {
        throw new BadRequestException('Not authorized to update this user');
      }
    }

    const user = await this.prisma.user.update({
      where: { id },
      data: {
        name: data.name,
        avatar: data.avatar,
        bio: data.bio,
        timezone: data.timezone,
        language: data.language,
      },
      include: {
        memberships: {
          include: { organization: true },
        },
      },
    });

    return this.sanitizeUser(user);
  }

  async deactivate(id: string, organizationId: string) {
    await this.prisma.user.update({
      where: { id },
      data: { isActive: false },
    });

    return { message: 'User deactivated successfully' };
  }

  private sanitizeUser(user: any) {
    const { password, googleId, ...sanitized } = user;
    return sanitized;
  }
}
