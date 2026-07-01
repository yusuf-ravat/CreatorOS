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
import { AnalyticsService } from './analytics.service';

@ApiTags('analytics')
@Controller('analytics')
export class AnalyticsController {
  constructor(private analyticsService: AnalyticsService) {}

  @Get()
  @ApiOperation({ summary: 'Get all analytics with pagination' })
  async findAll(
    @Query('page', () => 1) page: number,
    @Query('limit', () => 20) limit: number,
  ) {
    return this.analyticsService.findAll({ page, limit });
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get analytics by ID' })
  async findOne(@Param('id', ParseUUIDPipe) id: string) {
    return this.analyticsService.findOne(id);
  }

  @Post()
  @ApiOperation({ summary: 'Create new analytics' })
  async create(@Body() dto: any) {
    return this.analyticsService.create(dto);
  }

  @Put(':id')
  @ApiOperation({ summary: 'Update analytics' })
  async update(@Param('id', ParseUUIDPipe) id: string, @Body() dto: any) {
    return this.analyticsService.update(id, dto);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete analytics' })
  async remove(@Param('id', ParseUUIDPipe) id: string) {
    return this.analyticsService.remove(id);
  }
}
