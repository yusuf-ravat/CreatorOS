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
import { FilesService } from './files.service';

@ApiTags('files')
@Controller('files')
export class FilesController {
  constructor(private filesService: FilesService) {}

  @Get()
  @ApiOperation({ summary: 'Get all files with pagination' })
  async findAll(
    @Query('page', () => 1) page: number,
    @Query('limit', () => 20) limit: number,
  ) {
    return this.filesService.findAll({ page, limit });
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get files by ID' })
  async findOne(@Param('id', ParseUUIDPipe) id: string) {
    return this.filesService.findOne(id);
  }

  @Post()
  @ApiOperation({ summary: 'Create new files' })
  async create(@Body() dto: any) {
    return this.filesService.create(dto);
  }

  @Put(':id')
  @ApiOperation({ summary: 'Update files' })
  async update(@Param('id', ParseUUIDPipe) id: string, @Body() dto: any) {
    return this.filesService.update(id, dto);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete files' })
  async remove(@Param('id', ParseUUIDPipe) id: string) {
    return this.filesService.remove(id);
  }
}
