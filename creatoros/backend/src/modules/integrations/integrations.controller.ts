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
import { IntegrationsService } from './integrations.service';

@ApiTags('integrations')
@Controller('integrations')
export class IntegrationsController {
  constructor(private integrationsService: IntegrationsService) {}

  @Get()
  @ApiOperation({ summary: 'Get all integrations with pagination' })
  async findAll(
    @Query('page', () => 1) page: number,
    @Query('limit', () => 20) limit: number,
  ) {
    return this.integrationsService.findAll({ page, limit });
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get integrations by ID' })
  async findOne(@Param('id', ParseUUIDPipe) id: string) {
    return this.integrationsService.findOne(id);
  }

  @Post()
  @ApiOperation({ summary: 'Create new integrations' })
  async create(@Body() dto: any) {
    return this.integrationsService.create(dto);
  }

  @Put(':id')
  @ApiOperation({ summary: 'Update integrations' })
  async update(@Param('id', ParseUUIDPipe) id: string, @Body() dto: any) {
    return this.integrationsService.update(id, dto);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete integrations' })
  async remove(@Param('id', ParseUUIDPipe) id: string) {
    return this.integrationsService.remove(id);
  }
}
