import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';
import { CreateBrandDto, UpdateBrandDto, BrandStatus } from './dto/brand.dto';

interface FindBrandsParams {
  page: number;
  limit: number;
  search?: string;
  industry?: string;
  status?: string;
}

@Injectable()
export class BrandsService {
  constructor(private prisma: PrismaClient) {}

  async findAll(params: FindBrandsParams) {
    const { page, limit, search, industry, status } = params;
    const skip = (page - 1) * limit;

    const where: any = {};

    if (search) {
      where.OR = [
        { name: { contains: search, mode: 'insensitive' } },
        { company: { contains: search, mode: 'insensitive' } },
        { contactPerson: { contains: search, mode: 'insensitive' } },
        { email: { contains: search, mode: 'insensitive' } },
      ];
    }

    if (industry) {
      where.industry = industry;
    }

    if (status) {
      where.status = status;
    }

    const [brands, total] = await Promise.all([
      this.prisma.brand.findMany({
        where,
        skip,
        take: limit,
        orderBy: { createdAt: 'desc' },
        include: {
          deals: {
            select: {
              id: true,
              campaignName: true,
              status: true,
              budget: true,
            },
          },
        },
      }),
      this.prisma.brand.count({ where }),
    ]);

    return {
      data: brands,
      meta: {
        total,
        page,
        limit,
        totalPages: Math.ceil(total / limit),
      },
    };
  }

  async findOne(id: string) {
    const brand = await this.prisma.brand.findUnique({
      where: { id },
      include: {
        deals: {
          orderBy: { createdAt: 'desc' },
        },
      },
    });

    if (!brand) {
      throw new NotFoundException(`Brand with ID ${id} not found`);
    }

    return brand;
  }

  async create(dto: CreateBrandDto) {
    return this.prisma.brand.create({
      data: {
        ...dto,
        status: dto.status || BrandStatus.PROSPECT,
      },
    });
  }

  async update(id: string, dto: UpdateBrandDto) {
    const brand = await this.prisma.brand.findUnique({ where: { id } });

    if (!brand) {
      throw new NotFoundException(`Brand with ID ${id} not found`);
    }

    return this.prisma.brand.update({
      where: { id },
      data: dto,
    });
  }

  async remove(id: string) {
    const brand = await this.prisma.brand.findUnique({ where: { id } });

    if (!brand) {
      throw new NotFoundException(`Brand with ID ${id} not found`);
    }

    await this.prisma.brand.delete({ where: { id } });

    return { message: 'Brand deleted successfully' };
  }
}
