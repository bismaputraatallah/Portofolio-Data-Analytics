-- Exploratory Data ANalyst
SELECT *
FROM layoffs_staging2;

-- How much company laid off and how max the percentage
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

-- where company laid off all the employees
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

-- Which one the highest laid off based on company
SELECT company,
	SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY 1
ORDER BY 2 DESC;

SELECT MAX(date), MIN(date)
FROM layoffs_staging2;

-- the most laid off based on total industry
SELECT industry,
	SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY 1
ORDER BY 2 DESC;

-- the most laid off based on total Country
SELECT country,
	SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY 1
ORDER BY 2 DESC;

-- FOr Indonesia
SELECT location,
	industry,
    company,
    SUM(total_laid_off)
FROM layoffs_staging2
WHERE country = 'Indonesia'
GROUP BY 1,2,3
ORDER BY 4 DESC;

-- Information percentage laid off and total laid off by year
SELECT YEAR(`date`) AS year,
    SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY 1
ORDER BY 1 ASC;

-- total laid_off per month
SELECT 
    MONTH(`date`) AS month_per,
    SUM(total_laid_off) AS monthly_total,
    SUM(SUM(total_laid_off)) OVER (ORDER BY MONTH(`date`)) AS rolling_total
FROM layoffs_staging2
GROUP BY MONTH(`date`)
ORDER BY month_per ASC;


SELECT 
	SUBSTRING(`date`, 1, 7) AS year_per_month,
	SUM(total_laid_off) AS total_laid
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY 1
ORDER BY 1;

-- OVER clause adalah fitur dalam SQL yang digunakan untuk melakukan kalkulasi agregasi atau fungsi analitik 
-- pada subset data tanpa harus mengelompokkan hasil (tanpa menggunakan GROUP BY) jadi menjumlahkan berdasarkan peningkatan.
WITH rolling AS (
SELECT 
	SUBSTRING(`date`, 1, 7) AS year_per_month,
	SUM(total_laid_off) AS total_laid
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY 1
ORDER BY 1)
SELECT 
	year_per_month,
    total_laid,
    SUM(total_laid) OVER(ORDER BY year_per_month) AS rolling_total
FROM rolling;

-- for company laid of per year
SELECT company, 
	YEAR(date),
	SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY 1, 2
ORDER BY 3 DESC;

WITH company_year (company, years, total_laid_off) AS (
SELECT company, 
	YEAR(date),
	SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY 1, 28),
company_year_rank AS (
SELECT *,
dense_rank() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
FROM company_year
WHERE years IS NOT NULL)
SELECT *
FROM company_year_rank
WHERE ranking <= 5;

