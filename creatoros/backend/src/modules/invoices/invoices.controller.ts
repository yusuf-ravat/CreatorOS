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
import { InvoicesService } from './invoices.service';

@ApiTags('invoices')
@Controller('invoices')
export class InvoicesController {
  constructor(private invoicesService: InvoicesService) {}

  @Get()
  @ApiOperation({ summary: 'Get all invoices with pagination' })
  async findAll(
    @Query('page', () => 1) page: number,
    @Query('limit', () => 20) limit: number,
  ) {
    return this.invoicesService.findAll({ page, limit });
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get invoices by ID' })
  async findOne(@Param('id', ParseUUIDPipe) id: string) {
    return this.invoicesService.findOne(id);
  }

  @Post()
  @ApiOperation({ summary: 'Create new invoices' })
  async create(@Body() dto: any) {
    return this.invoicesService.create(dto);
  }

  @Put(':id')
  @ApiOperation({ summary: 'Update invoices' })
  async update(@Param('id', ParseUUIDPipe) id: string, @Body() dto: any) {
    return this.invoicesService.update(id, dto);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete invoices' })
  async remove(@Param('id', ParseUUIDPipe) id: string) {
    return this.invoicesService.remove(id);
  }
}
