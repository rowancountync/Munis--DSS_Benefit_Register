use mu_live

declare @BeginDate datetime
declare @EndDate datetime

/* DECLARE @Location char(6)
DECLARE @Group char(4)	
DECLARE @EmployeeNbr int */

set @BeginDate = '01/01/2018 12:00:00.000 AM'
set @EndDate = '01/31/2018 12:00:00.000 AM'

SELECT DISTINCT   
		    em.a_employee_number, 
			em.a_name_last, 
			em.a_name_first, 
			em.a_name_minit,
			ud.us_description, 
			jc.a_job_class_descsh, 
          
           (SELECT        SUM(dh2.dh_emplr_amount)
            FROM            pr_ded_history AS dh2
            WHERE        ((dh2.a_employee_number = em.a_employee_number) AND (dh2.a_deduction_code = '1000') AND (dh2.dh_check_date BETWEEN @BeginDate AND @EndDate) AND ((dh2.dh_exp_org = '1155310') OR (dh2.dh_exp_org BETWEEN '1155311' AND '1155385'))) OR
            ((dh2.a_employee_number = em.a_employee_number) AND (dh2.a_deduction_code = '1000') AND (dh2.dh_check_date BETWEEN @BeginDate AND @EndDate) AND (dh2.a_location = '5300') AND (dh2.dh_exp_object = '9201')) OR
            ((dh2.a_employee_number = em.a_employee_number) AND (dh2.a_deduction_code = '1000') AND (dh2.dh_check_date BETWEEN @BeginDate AND @EndDate) AND (dh2.a_location = '4160') AND (dh2.dh_exp_object = '9201'))) AS 'empr_SS',
           (SELECT        SUM(dh3.dh_emplr_amount)
            FROM            pr_ded_history AS dh3
            WHERE        ((dh3.a_employee_number = em.a_employee_number) AND (dh3.a_deduction_code = '1100') AND (dh3.dh_check_date BETWEEN @BeginDate AND @EndDate) AND ((dh3.dh_exp_org = '1155310') OR (dh3.dh_exp_org BETWEEN '1155311' AND '1155385')))  OR
            ((dh3.a_employee_number = em.a_employee_number) AND (dh3.a_deduction_code = '1100') AND (dh3.dh_check_date BETWEEN @BeginDate AND @EndDate) AND (dh3.a_location = '5300') AND (dh3.dh_exp_object = '9201')) OR
            ((dh3.a_employee_number = em.a_employee_number) AND (dh3.a_deduction_code = '1100') AND (dh3.dh_check_date BETWEEN @BeginDate AND @EndDate) AND (dh3.a_location = '4160') AND (dh3.dh_exp_object = '9201'))) AS 'empr_med',
           (SELECT        SUM(dh4.dh_emplr_amount)
            FROM            pr_ded_history AS dh4
            WHERE        ((dh4.a_employee_number = em.a_employee_number) AND (dh4.a_deduction_code = '7000') AND (dh4.dh_check_date BETWEEN @BeginDate AND @EndDate) AND ((dh4.dh_exp_org = '1155310') OR (dh4.dh_exp_org BETWEEN '1155311' AND '1155385'))) OR
            ((dh4.a_employee_number = em.a_employee_number) AND (dh4.a_deduction_code = '7000') AND (dh4.dh_check_date BETWEEN @BeginDate AND @EndDate) AND (dh4.a_location = '5300') AND (dh4.dh_exp_object = '9201')) OR
            ((dh4.a_employee_number = em.a_employee_number) AND (dh4.a_deduction_code = '7000') AND (dh4.dh_check_date BETWEEN @BeginDate AND @EndDate) AND (dh4.a_location = '4160') AND (dh4.dh_exp_object = '9201'))) AS 'empr_retire',
            ISNULL ((SELECT        SUM(dh5.dh_emplr_amount)
            FROM            pr_ded_history AS dh5
            WHERE        ((dh5.a_employee_number = em.a_employee_number) AND (dh5.a_deduction_code = '7505') AND (dh5.dh_check_date BETWEEN @BeginDate AND @EndDate) AND ((dh5.dh_exp_org = '1155310') OR (dh5.dh_exp_org BETWEEN '1155311' AND '1155385'))) OR
            ((dh5.a_employee_number = em.a_employee_number) AND (dh5.a_deduction_code = '7505') AND (dh5.dh_check_date BETWEEN @BeginDate AND @EndDate) AND (dh5.a_location = '5300') AND (dh5.dh_exp_object = '9201')) OR
            ((dh5.a_employee_number = em.a_employee_number) AND (dh5.a_deduction_code = '7505') AND (dh5.dh_check_date BETWEEN @BeginDate AND @EndDate) AND (dh5.a_location = '4160') AND (dh5.dh_exp_object = '9201'))), 0) AS 'empr_401k',
			(SELECT        SUM(dh6.dh_emplr_amount)
            FROM            pr_ded_history AS dh6
            WHERE        ((dh6.a_employee_number = em.a_employee_number) AND (dh6.a_deduction_code IN ('2000', '2001', '2005', '2015')) AND (dh6.dh_check_date BETWEEN @BeginDate AND @EndDate) AND ((dh6.dh_exp_org = '1155310') OR (dh6.dh_exp_org BETWEEN '1155311' AND '1155385'))) OR
            ((dh6.a_employee_number = em.a_employee_number) AND (dh6.a_deduction_code BETWEEN 2000 AND 2015) AND(dh6.dh_check_date BETWEEN @BeginDate AND @EndDate) AND (dh6.a_location = '5300') AND (dh6.dh_exp_object = '520005')) OR
            ((dh6.a_employee_number = em.a_employee_number) AND (dh6.a_deduction_code BETWEEN 2000 AND 2015) AND(dh6.dh_check_date BETWEEN @BeginDate AND @EndDate) AND (dh6.a_location = '4160') AND (dh6.dh_exp_object = '520005'))) AS 'empr_hosp',
          
		   (SELECT        SUM(eh.eh_total_amount) 
            FROM            pr_earn_history AS eh
            WHERE        ((eh.a_pay_type BETWEEN '100' AND '899') and (eh.a_employee_number = em.a_employee_number) AND (eh.eh_check_date BETWEEN @BeginDate AND @EndDate) AND ((eh.eh_org = '1155310') OR (eh.eh_org BETWEEN '1155311' AND '1155385')) AND (eh.eh_object BETWEEN '510005' AND '510015')) OR
            ((eh.a_pay_type BETWEEN '100' AND '899') AND (eh.a_employee_number = em.a_employee_number) AND (eh.eh_check_date BETWEEN @BeginDate AND @EndDate) AND (eh.eh_object = '510005') AND (eh.eh_location = '5300') AND (eh.eh_object BETWEEN '510005' AND '510015')) OR
            ((eh.a_pay_type BETWEEN '100' AND '899') AND (eh.a_employee_number = em.a_employee_number) AND (eh.eh_check_date BETWEEN @BeginDate AND @EndDate) AND (eh.eh_object = '510005') AND (eh.eh_location = '4160') AND (eh.eh_object BETWEEN '510005' AND '510015'))) AS 'EarnSalary',
			
			jp.a_position_code
FROM        pr_employee_mast em LEFT OUTER JOIN
                         pr_job_class jc ON em.a_job_code_primary = jc.a_job_class_code AND jc.a_projection = 0   
						 LEFT OUTER JOIN
						 pr_job_pay as jp ON jp.a_employee_number = em.a_employee_number
						 LEFT OUTER JOIN
						 pr_employee_userdef ud ON ud.a_employee_number = em.a_employee_number AND ud.us_field_code = 'DSS'
WHERE      (em.a_projection = 0) AND (em.a_employee_number IN
                             (SELECT DISTINCT dh7.a_employee_number
                               FROM            pr_ded_history AS dh7
                               WHERE        (((dh7.dh_exp_org = '1155310') OR (dh7.dh_exp_org BETWEEN '1155311' AND '1155385')) AND (dh7.dh_check_date BETWEEN @BeginDate AND @EndDate) AND (dh7.a_deduction_code = 1000)) OR
                               ((dh7.dh_check_date BETWEEN @BeginDate AND @EndDate) AND (dh7.a_deduction_code = 1000) AND (dh7.a_location = '5300') AND (dh7.dh_exp_object = '9201')) OR
                               ((dh7.dh_check_date BETWEEN @BeginDate AND @EndDate) AND (dh7.a_deduction_code = 1000) AND (dh7.a_location = '4160') AND (dh7.dh_exp_object = '9201'))))
ORDER BY em.a_name_last, em.a_name_first, em.a_name_minit
 