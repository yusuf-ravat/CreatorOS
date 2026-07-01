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
import { NotificationsService } from './notifications.service';

@ApiTags('notifications')
@Controller('notifications')
export class NotificationsController {
  constructor(private notificationsService: NotificationsService) {}

  @Get()
  @ApiOperation({ summary: 'Get all notifications with pagination' })
  async findAll(
    @Query('page', () => 1) page: number,
    @Query('limit', () => 20) limit: number,
  ) {
    return this.notificationsService.findAll({ page, limit });
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get notifications by ID' })
  async findOne(@Param('id', ParseUUIDPipe) id: string) {
    return this.notificationsService.findOne(id);
  }

  @Post()
  @ApiOperation({ summary: 'Create new notifications' })
  async create(@Body() dto: any) {
    return this.notificationsService.create(dto);
  }

  @Put(':id')
  @ApiOperation({ summary: 'Update notifications' })
  async update(@Param('id', ParseUUIDPipe) id: string, @Body() dto: any) {
    return this.notificationsService.update(id, dto);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete notifications' })
  async remove(@Param('id', ParseUUIDPipe) id: string) {
    return this.notificationsService.remove(id);
  }
}
