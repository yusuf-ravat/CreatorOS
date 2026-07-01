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
import { DealsService } from './deals.service';

@ApiTags('deals')
@Controller('deals')
export class DealsController {
  constructor(private dealsService: DealsService) {}

  @Get()
  @ApiOperation({ summary: 'Get all deals with pagination' })
  async findAll(
    @Query('page', () => 1) page: number,
    @Query('limit', () => 20) limit: number,
  ) {
    return this.dealsService.findAll({ page, limit });
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get deals by ID' })
  async findOne(@Param('id', ParseUUIDPipe) id: string) {
    return this.dealsService.findOne(id);
  }

  @Post()
  @ApiOperation({ summary: 'Create new deals' })
  async create(@Body() dto: any) {
    return this.dealsService.create(dto);
  }

  @Put(':id')
  @ApiOperation({ summary: 'Update deals' })
  async update(@Param('id', ParseUUIDPipe) id: string, @Body() dto: any) {
    return this.dealsService.update(id, dto);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete deals' })
  async remove(@Param('id', ParseUUIDPipe) id: string) {
    return this.dealsService.remove(id);
  }
}
