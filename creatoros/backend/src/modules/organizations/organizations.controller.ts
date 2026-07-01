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
import { OrganizationsService } from './organizations.service';

@ApiTags('organizations')
@Controller('organizations')
export class OrganizationsController {
  constructor(private organizationsService: OrganizationsService) {}

  @Get()
  @ApiOperation({ summary: 'Get all organizations with pagination' })
  async findAll(
    @Query('page', () => 1) page: number,
    @Query('limit', () => 20) limit: number,
  ) {
    return this.organizationsService.findAll({ page, limit });
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get organizations by ID' })
  async findOne(@Param('id', ParseUUIDPipe) id: string) {
    return this.organizationsService.findOne(id);
  }

  @Post()
  @ApiOperation({ summary: 'Create new organizations' })
  async create(@Body() dto: any) {
    return this.organizationsService.create(dto);
  }

  @Put(':id')
  @ApiOperation({ summary: 'Update organizations' })
  async update(@Param('id', ParseUUIDPipe) id: string, @Body() dto: any) {
    return this.organizationsService.update(id, dto);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete organizations' })
  async remove(@Param('id', ParseUUIDPipe) id: string) {
    return this.organizationsService.remove(id);
  }
}
