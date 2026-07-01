import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Body,
  Param,
  Query,
  Req,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse } from '@nestjs/swagger';
import { UsersService } from './users.service';
import { Roles } from '../../common/decorators';

@ApiTags('users')
@Controller('users')
export class UsersController {
  constructor(private usersService: UsersService) {}

  @Get()
  @ApiOperation({ summary: 'Get all users in organization' })
  async findAll(
    @Req() req: any,
    @Query('page', () => parseInt) page = 1,
    @Query('limit', () => parseInt) limit = 10,
    @Query('search') search?: string,
  ) {
    return this.usersService.findAll(req.user.organizationId, page, limit, search);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get user by ID' })
  async findOne(@Req() req: any, @Param('id') id: string) {
    return this.usersService.findOne(id, req.user.organizationId);
  }

  @Put(':id')
  @ApiOperation({ summary: 'Update user profile' })
  async update(@Req() req: any, @Param('id') id: string, @Body() body: any) {
    return this.usersService.update(id, req.user.id, body);
  }

  @Delete(':id')
  @Roles('OWNER', 'ADMIN')
  @ApiOperation({ summary: 'Deactivate user' })
  async deactivate(@Req() req: any, @Param('id') id: string) {
    return this.usersService.deactivate(id, req.user.organizationId);
  }

  @Get('me')
  @ApiOperation({ summary: 'Get current user profile' })
  async getProfile(@Req() req: any) {
    return this.usersService.findOne(req.user.id, req.user.organizationId);
  }

  @Put('me')
  @ApiOperation({ summary: 'Update current user profile' })
  async updateProfile(@Req() req: any, @Body() body: any) {
    return this.usersService.update(req.user.id, req.user.id, body);
  }
}
