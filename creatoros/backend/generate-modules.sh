#!/bin/bash

# Script to generate all remaining backend modules for CreatorOS

MODULES=("deals" "campaigns" "content" "contracts" "invoices" "payments" "expenses" "tasks" "files" "analytics" "ai" "notifications" "integrations" "organizations")

for MODULE in "${MODULES[@]}"; do
  MODULE_DIR="src/modules/$MODULE"
  
  # Create directory structure
  mkdir -p "$MODULE_DIR/dto"
  
  # Create module file
  MODULE_NAME=$(echo "$MODULE" | sed 's/.*/\u&/')
  cat > "$MODULE_DIR/${MODULE}.module.ts" << EOF
import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { ${MODULE_NAME}Controller } from './${MODULE}.controller';
import { ${MODULE_NAME}Service } from './${MODULE}.service';

@Module({
  imports: [PrismaModule],
  controllers: [${MODULE_NAME}Controller],
  providers: [${MODULE_NAME}Service],
  exports: [${MODULE_NAME}Service],
})
export class ${MODULE_NAME}Module {}
EOF

  # Create controller file
  cat > "$MODULE_DIR/${MODULE}.controller.ts" << EOF
import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Body,
  Param,
  Query,
  ParseUUIDPipe,
} from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { ${MODULE_NAME}Service } from './${MODULE}.service';

@ApiTags('${MODULE}')
@Controller('${MODULE}')
export class ${MODULE_NAME}Controller {
  constructor(private ${MODULE}Service: ${MODULE_NAME}Service) {}

  @Get()
  @ApiOperation({ summary: 'Get all ${MODULE} with pagination' })
  async findAll(
    @Query('page', () => 1) page: number,
    @Query('limit', () => 20) limit: number,
  ) {
    return this.${MODULE}Service.findAll({ page, limit });
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get ${MODULE} by ID' })
  async findOne(@Param('id', ParseUUIDPipe) id: string) {
    return this.${MODULE}Service.findOne(id);
  }

  @Post()
  @ApiOperation({ summary: 'Create new ${MODULE}' })
  async create(@Body() dto: any) {
    return this.${MODULE}Service.create(dto);
  }

  @Put(':id')
  @ApiOperation({ summary: 'Update ${MODULE}' })
  async update(@Param('id', ParseUUIDPipe) id: string, @Body() dto: any) {
    return this.${MODULE}Service.update(id, dto);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete ${MODULE}' })
  async remove(@Param('id', ParseUUIDPipe) id: string) {
    return this.${MODULE}Service.remove(id);
  }
}
EOF

  # Create service file
  SINGULAR=$(echo "$MODULE" | sed 's/s$//')
  cat > "$MODULE_DIR/${MODULE}.service.ts" << EOF
import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';

interface FindParams {
  page: number;
  limit: number;
}

@Injectable()
export class ${MODULE_NAME}Service {
  constructor(private prisma: PrismaClient) {}

  async findAll(params: FindParams) {
    const { page, limit } = params;
    const skip = (page - 1) * limit;

    const [items, total] = await Promise.all([
      this.prisma.${SINGULAR}.findMany({
        where: {},
        skip,
        take: limit,
        orderBy: { createdAt: 'desc' },
      }),
      this.prisma.${SINGULAR}.count({}),
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
    const item = await this.prisma.${SINGULAR}.findUnique({
      where: { id },
    });

    if (!item) {
      throw new NotFoundException('${MODULE_NAME} with ID \${id} not found');
    }

    return item;
  }

  async create(dto: any) {
    return this.prisma.${SINGULAR}.create({
      data: dto,
    });
  }

  async update(id: string, dto: any) {
    const item = await this.prisma.${SINGULAR}.findUnique({ where: { id } });

    if (!item) {
      throw new NotFoundException('${MODULE_NAME} with ID \${id} not found');
    }

    return this.prisma.${SINGULAR}.update({
      where: { id },
      data: dto,
    });
  }

  async remove(id: string) {
    const item = await this.prisma.${SINGULAR}.findUnique({ where: { id } });

    if (!item) {
      throw new NotFoundException('${MODULE_NAME} with ID \${id} not found');
    }

    await this.prisma.${SINGULAR}.delete({ where: { id } });

    return { message: '${MODULE_NAME} deleted successfully' };
  }
}
EOF

  # Create index file
  cat > "$MODULE_DIR/index.ts" << EOF
export * from './${MODULE}.module';
export * from './${MODULE}.controller';
export * from './${MODULE}.service';
EOF

  echo "Created module: $MODULE"
done

echo "All modules created successfully!"
