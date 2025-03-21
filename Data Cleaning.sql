


select * 
from layoffs_staging2;

DELETE FROM layoffs_staging2
WHERE row_num > 1
LIMIT 1000;

select *
from layoffs_staging2;

-- Standardizing data

select company ,trim(company)
from layoffs_staging2;


update layoffs_staging2
set company = trim(company);

select *
from layoffs_staging2;

select *
from layoffs_staging2
where industry like 'Crypto%';

update layoffs_staging2
set industry = 'Crypto'
where industry like 'Crypto%';

update layoffs_staging2
set country = trim(trailing '.' from country);

select distinct country
from layoffs_staging2;

select `date`,
str_to_date(`date` , '%m/%d/%Y')
from layoffs_staging2;


SELECT *
FROM layoffs_staging2
ORDER BY `date`;

update layoffs_staging2
set `date` = str_to_date(`date` , '%m/%d/%Y')
;

alter table layoffs_staging2 
modify column `date` date;

select *
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

select distinct industry
from layoffs_staging2;

select * 
from layoffs_staging2;

select t1.industry, t2.industry
from layoffs_staging2 t1
join layoffs_staging2 t2 
	on t1.company =t2.company
    and t1.location = t2.location
where ( t1.industry is null or t1.industry = '')
and t2.industry is not null;



update layoffs_staging2 t1
join layoffs_staging2 t2
	on t2.company = t2.company
set t1.industry = t2.industry 
where ( t1.industry is null or t1.industry = '')
and t2.industry is not null;

select  *
from layoffs_staging2
;


select  *
from layoffs_staging2
order by company;


WITH ranked AS (
  SELECT *, 
         ROW_NUMBER() OVER (
           PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
           ORDER BY (SELECT NULL)  -- no preference, random
         ) AS rd
  FROM layoffs_staging2
)
DELETE FROM layoffs_staging2
WHERE (company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) IN (
  SELECT company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
  FROM ranked
  WHERE rd > 1
);



select * 
from layoffs_staging2;


alter table layoffs_staging2
drop column row_num;