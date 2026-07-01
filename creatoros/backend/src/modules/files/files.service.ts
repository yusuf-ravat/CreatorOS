import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';

interface FindParams {
  page: number;
  limit: number;
}

@Injectable()
export class FilesService {
  constructor(private prisma: PrismaClient) {}

  async findAll(params: FindParams) {
    const { page, limit } = params;
    const skip = (page - 1) * limit;

    const [items, total] = await Promise.all([
      this.prisma.file.findMany({
        where: {},
        skip,
        take: limit,
        orderBy: { createdAt: 'desc' },
      }),
      this.prisma.file.count({}),
    ]);

    return {
      data: items,
      meta: {
        total,
        page,
        limit,
        totalPages: Math.ceil(total / limit),
      },
    };
  }

  async findOne(id: string) {
    const item = await this.prisma.file.findUnique({
      where: { id },
    });

    if (!item) {
      throw new NotFoundException('Files with ID ${id} not found');
    }

    return item;
  }

  async create(dto: any) {
    return this.prisma.file.create({
      data: dto,
    });
  }

  async update(id: string, dto: any) {
    const item = await this.prisma.file.findUnique({ where: { id } });

    if (!item) {
      throw new NotFoundException('Files with ID ${id} not found');
    }

    return this.prisma.file.update({
      where: { id },
      data: dto,
    });
  }

  async remove(id: string) {
    const item = await this.prisma.file.findUnique({ where: { id } });

    if (!item) {
      throw new NotFoundException('Files with ID ${id} not found');
    }

    await this.prisma.file.delete({ where: { id } });

    return { message: 'Files deleted successfully' };
  }
}
