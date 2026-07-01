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
import { AiService } from './ai.service';

@ApiTags('ai')
@Controller('ai')
export class AiController {
  constructor(private aiService: AiService) {}

  @Get()
  @ApiOperation({ summary: 'Get all ai with pagination' })
  async findAll(
    @Query('page', () => 1) page: number,
    @Query('limit', () => 20) limit: number,
  ) {
    return this.aiService.findAll({ page, limit });
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get ai by ID' })
  async findOne(@Param('id', ParseUUIDPipe) id: string) {
    return this.aiService.findOne(id);
  }

  @Post()
  @ApiOperation({ summary: 'Create new ai' })
  async create(@Body() dto: any) {
    return this.aiService.create(dto);
  }

  @Put(':id')
  @ApiOperation({ summary: 'Update ai' })
  async update(@Param('id', ParseUUIDPipe) id: string, @Body() dto: any) {
    return this.aiService.update(id, dto);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete ai' })
  async remove(@Param('id', ParseUUIDPipe) id: string) {
    return this.aiService.remove(id);
  }
}
