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
import { ContractsService } from './contracts.service';

@ApiTags('contracts')
@Controller('contracts')
export class ContractsController {
  constructor(private contractsService: ContractsService) {}

  @Get()
  @ApiOperation({ summary: 'Get all contracts with pagination' })
  async findAll(
    @Query('page', () => 1) page: number,
    @Query('limit', () => 20) limit: number,
  ) {
    return this.contractsService.findAll({ page, limit });
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get contracts by ID' })
  async findOne(@Param('id', ParseUUIDPipe) id: string) {
    return this.contractsService.findOne(id);
  }

  @Post()
  @ApiOperation({ summary: 'Create new contracts' })
  async create(@Body() dto: any) {
    return this.contractsService.create(dto);
  }

  @Put(':id')
  @ApiOperation({ summary: 'Update contracts' })
  async update(@Param('id', ParseUUIDPipe) id: string, @Body() dto: any) {
    return this.contractsService.update(id, dto);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete contracts' })
  async remove(@Param('id', ParseUUIDPipe) id: string) {
    return this.contractsService.remove(id);
  }
}
