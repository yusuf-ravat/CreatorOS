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
import { CampaignsService } from './campaigns.service';

@ApiTags('campaigns')
@Controller('campaigns')
export class CampaignsController {
  constructor(private campaignsService: CampaignsService) {}

  @Get()
  @ApiOperation({ summary: 'Get all campaigns with pagination' })
  async findAll(
    @Query('page', () => 1) page: number,
    @Query('limit', () => 20) limit: number,
  ) {
    return this.campaignsService.findAll({ page, limit });
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get campaigns by ID' })
  async findOne(@Param('id', ParseUUIDPipe) id: string) {
    return this.campaignsService.findOne(id);
  }

  @Post()
  @ApiOperation({ summary: 'Create new campaigns' })
  async create(@Body() dto: any) {
    return this.campaignsService.create(dto);
  }

  @Put(':id')
  @ApiOperation({ summary: 'Update campaigns' })
  async update(@Param('id', ParseUUIDPipe) id: string, @Body() dto: any) {
    return this.campaignsService.update(id, dto);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete campaigns' })
  async remove(@Param('id', ParseUUIDPipe) id: string) {
    return this.campaignsService.remove(id);
  }
}
