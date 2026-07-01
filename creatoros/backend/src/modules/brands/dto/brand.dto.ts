import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsString, IsEmail, IsOptional, IsUrl, IsEnum } from 'class-validator';

export enum BrandStatus {
  ACTIVE = 'active',
  INACTIVE = 'inactive',
  PROSPECT = 'prospect',
}

export class CreateBrandDto {
  @ApiProperty({ example: 'Nike' })
  @IsString()
  name: string;

  @ApiPropertyOptional({ example: 'Nike Inc.' })
  @IsString()
  @IsOptional()
  company?: string;

  @ApiPropertyOptional({ example: 'https://nike.com' })
  @IsUrl()
  @IsOptional()
  website?: string;

  @ApiPropertyOptional({ example: 'Sports & Fitness' })
  @IsString()
  @IsOptional()
  industry?: string;

  @ApiPropertyOptional({ example: 'John Smith' })
  @IsString()
  @IsOptional()
  contactPerson?: string;

  @ApiPropertyOptional({ example: 'john@nike.com' })
  @IsEmail()
  @IsOptional()
  email?: string;

  @ApiPropertyOptional({ example: '+1-555-0123' })
  @IsString()
  @IsOptional()
  phone?: string;

  @ApiPropertyOptional({ example: 'USA' })
  @IsString()
  @IsOptional()
  country?: string;

  @ApiPropertyOptional({ example: 'https://instagram.com/nike' })
  @IsUrl()
  @IsOptional()
  instagram?: string;

  @ApiPropertyOptional({ example: 'https://twitter.com/nike' })
  @IsUrl()
  @IsOptional()
  twitter?: string;

  @ApiPropertyOptional({ example: 'https://linkedin.com/company/nike' })
  @IsUrl()
  @IsOptional()
  linkedin?: string;

  @ApiPropertyOptional({ example: 'Great potential for long-term partnership' })
  @IsString()
  @IsOptional()
  notes?: string;

  @ApiPropertyOptional({ default: BrandStatus.PROSPECT })
  @IsEnum(BrandStatus)
  @IsOptional()
  status?: BrandStatus;
}

export class UpdateBrandDto {
  @ApiPropertyOptional({ example: 'Nike' })
  @IsString()
  @IsOptional()
  name?: string;

  @ApiPropertyOptional({ example: 'Nike Inc.' })
  @IsString()
  @IsOptional()
  company?: string;

  @ApiPropertyOptional({ example: 'https://nike.com' })
  @IsUrl()
  @IsOptional()
  website?: string;

  @ApiPropertyOptional({ example: 'Sports & Fitness' })
  @IsString()
  @IsOptional()
  industry?: string;

  @ApiPropertyOptional({ example: 'John Smith' })
  @IsString()
  @IsOptional()
  contactPerson?: string;

  @ApiPropertyOptional({ example: 'john@nike.com' })
  @IsEmail()
  @IsOptional()
  email?: string;

  @ApiPropertyOptional({ example: '+1-555-0123' })
  @IsString()
  @IsOptional()
  phone?: string;

  @ApiPropertyOptional({ example: 'USA' })
  @IsString()
  @IsOptional()
  country?: string;

  @ApiPropertyOptional({ example: 'https://instagram.com/nike' })
  @IsUrl()
  @IsOptional()
  instagram?: string;

  @ApiPropertyOptional({ example: 'https://twitter.com/nike' })
  @IsUrl()
  @IsOptional()
  twitter?: string;

  @ApiPropertyOptional({ example: 'https://linkedin.com/company/nike' })
  @IsUrl()
  @IsOptional()
  linkedin?: string;

  @ApiPropertyOptional({ example: 'Great potential for long-term partnership' })
  @IsString()
  @IsOptional()
  notes?: string;

  @ApiPropertyOptional({ enum: BrandStatus })
  @IsEnum(BrandStatus)
  @IsOptional()
  status?: BrandStatus;
}
