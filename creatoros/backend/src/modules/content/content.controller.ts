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
import { ContentService } from './content.service';

@ApiTags('content')
@Controller('content')
export class ContentController {
  constructor(private contentService: ContentService) {}

  @Get()
  @ApiOperation({ summary: 'Get all content with pagination' })
  async findAll(
    @Query('page', () => 1) page: number,
    @Query('limit', () => 20) limit: number,
  ) {
    return this.contentService.findAll({ page, limit });
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get content by ID' })
  async findOne(@Param('id', ParseUUIDPipe) id: string) {
    return this.contentService.findOne(id);
  }

  @Post()
  @ApiOperation({ summary: 'Create new content' })
  async create(@Body() dto: any) {
    return this.contentService.create(dto);
  }

  @Put(':id')
  @ApiOperation({ summary: 'Update content' })
  async update(@Param('id', ParseUUIDPipe) id: string, @Body() dto: any) {
    return this.contentService.update(id, dto);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete content' })
  async remove(@Param('id', ParseUUIDPipe) id: string) {
    return this.contentService.remove(id);
  }
}
