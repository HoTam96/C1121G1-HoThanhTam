
-- task2
select * from employee where employee.e_name like 'H%' or
 employee.e_name like 'T%'or employee.e_name like 'K%' and char_length	(e_name)between 0 and 15;
 
 -- task3 3.	Hiển thị thông tin của tất cả khách hàng có độ tuổi từ 18 đến 50 tuổi và có địa chỉ
 -- ở “Đà Nẵng” hoặc “Quảng Trị”.
 
select * from customer where ((round(datediff(curdate(), customer.day_of_birth)/365.0))between 18 and 50 ) and
customer.c_address like '%đà nẵng%' or  customer.c_address like '%quảng trị%';
 
 
 
 select customer.customer_id, customer.c_name, count(customer.customer_id) as 'so_lan_dat_phong' from customer
inner join type_customer on type_customer.type_customer_id = customer.type_customer_id
inner join contract on customer.customer_id = contract.customer_id
where type_customer.type_customer_id = 1
group by customer.customer_id
order by so_lan_dat_phong asc;
 
-- -- tast 5

select customer.customer_id,customer.c_name,type_customer.type_name_customer, contract.contract_id,
 contract.start_date_contract, sum( ifnull(service.rental_cost,0)+
 ifnull( detail_contract.amount,0)*ifnull(accompanied_service.price,0))
 as tong_tien from customer
 left join type_customer on type_customer.type_customer_id = customer.type_customer_id
  left join contract on customer.customer_id = contract.customer_id
  left join service on contract.service_id = service.service_id
 left  join detail_contract on contract.contract_id= detail_contract.contract_id
  left join accompanied_service on detail_contract.service_code = accompanied_service.service_code
 group by contract.contract_id;
 
-- task 6 6.	Hiển thị ma_dich_vu, ten_dich_vu, dien_tich, chi_phi_thue,
--  ten_loai_dich_vu của tất cả các loại dịch vụ chưa từng được khách hàng thực 
--  hiện đặt từ quý 1 của năm 2021 (Quý 1 là tháng 1, 2, 3)002E
 
 select service.service_id, service.service_name,service.area,service.rental_cost,type_service.type_name_service
 from type_service
left join service on type_service.type_service_id = service.type_service_id
left join contract on contract.service_id = service.service_id
where service.service_id not in (select contract.service_id from contract where (month(start_date_contract) between 1 and 3) and (year(start_date_contract) = 2021))
group by service.service_id
order by service.area desc; 



-- task 7.	Hiển thị thông tin ma_dich_vu, ten_dich_vu, dien_tich, so_nguoi_toi_da, 
-- chi_phi_thue, ten_loai_dich_vu của tất cả các loại dịch vụ đã từng được khách hàng đặt
--  phòng trong năm 2020 nhưng chưa từng được khách hàng đặt phòng trong năm 2021.
 
select service.service_id, service.service_name,service.area,service.people_max,service.rental_cost,
type_service.type_name_service from type_service
 join service on service.type_service_id = type_service.type_service_id
 join contract on contract.service_id = service.service_id
where (service.service_id in (select contract.service_id from contract where  year(start_date_contract)=2020)) and 
(service.service_id not in (select contract.service_id from contract 
where year(start_date_contract)=2021)) group by service.service_id;

-- 8.	Hiển thị thông tin ho_ten khách hàng có trong hệ thống, với yêu cầu ho_ten không trùng nhau.
-- Học viên sử dụng theo 3 cách khác nhau để thực hiện yêu cầu trên.
-- c1
select distinct customer.c_name from customer  ;
-- c2
select customer.c_name from customer group by c_name;
-- c3
select customer.c_name from customer union select customer.c_name from customer;

--  9.	Thực hiện thống kê doanh thu theo tháng, nghĩa là tương ứng với mỗi tháng trong 
--  năm 2021 thì sẽ có bao nhiêu khách hàng thực hiện đặt phòng

select month(start_date_contract)as `month`, count(contract.contract_id)as so_luong from contract
where year(start_date_contract)=2021 group by `month`;

-- task 10.	Hiển thị thông tin tương ứng với từng hợp đồng thì đã sử dụng bao nhiêu dịch vụ đi kèm.
--  Kết quả hiển thị bao gồm ma_hop_dong, ngay_lam_hop_dong, ngay_ket_thuc, tien_dat_coc, 
--  so_luong_dich_vu_di_kem (được tính dựa trên việc sum so_luong ở dich_vu_di_kem).

select contract.contract_id, contract.start_date_contract,
 contract.end_date_contract, contract.deposits, sum(ifnull(detail_contract.amount,0))as so_luong from contract
 left  join detail_contract on contract.contract_id = detail_contract.contract_id
 left   join  accompanied_service on detail_contract.service_code = accompanied_service.service_code 
 group by contract.contract_id ;
 
 
--   task 11.	Hiển thị thông tin các dịch vụ đi kèm đã được sử dụng bởi những khách hàng 
--  có ten_loai_khach là “Diamond” và có dia_chi ở “Vinh” hoặc “Quảng Ngãi”.

 select accompanied_service.service_code, accompanied_service.name_service from accompanied_service
 join detail_contract on detail_contract.service_code = accompanied_service.service_code
 join contract on contract.contract_id = detail_contract.contract_id
 join customer on customer.customer_id = contract.customer_id
 join type_customer on type_customer.type_customer_id = customer.type_customer_id
 where (type_customer.type_customer_id = 1 and (customer.c_address 
 like '%Quảng Ngãi%' or customer.c_address like '%Vinh%' ));

-- task  12.	Hiển thị thông tin ma_hop_dong, ho_ten (nhân viên), ho_ten (khách hàng), 
-- so_dien_thoai (khách hàng), ten_dich_vu, so_luong_dich_vu_di_kem 
-- (được tính dựa trên việc sum so_luong ở dich_vu_di_kem), 
-- tien_dat_coc của tất cả các dịch vụ đã từng được khách hàng đặt vào 3 tháng cuối năm 2020 
-- nhưng chưa từng được khách hàng đặt vào 6 tháng đầu năm 2021.
 

select contract.contract_id, employee.e_name, customer.c_name,customer.phone_number,
service.service_name,sum(ifnull(detail_contract.amount,0))as so_luong, contract.deposits from contract
left join employee on employee.employee_id = contract.employee_id
left join service on service.service_id = contract.service_id
left join customer on customer.customer_id = contract.customer_id
left join detail_contract on detail_contract.contract_id = contract.contract_id
where contract.contract_id in (select contract.contract_id from contract where year(start_date_contract)=2020
 and (month(start_date_contract) between 10 and 12)) and (contract.contract_id not in 
 (select contract.contract_id from contract where year(start_date_contract)=2021 
 and month(start_date_contract) between 1 and 6)) group by contract.contract_id ;
 

-- task 13 13.	Hiển thị thông tin các Dịch vụ đi kèm được sử dụng nhiều nhất bởi
--  các Khách hàng đã đặt phòng. (Lưu ý là có thể có nhiều dịch vụ có số lần sử dụng nhiều như nhau).
  
  select  accompanied_service.service_code, accompanied_service.name_service,  sum(ifnull(detail_contract.amount,0)) as so_luong from
  detail_contract
  join accompanied_service on detail_contract.service_code = accompanied_service.service_code
 join contract on contract.contract_id = detail_contract.contract_id group by accompanied_service.service_code
  having so_luong >= ( select max(detail_contract.amount)from detail_contract);
  
--   task 14 14.	Hiển thị thông tin tất cả các Dịch vụ đi kèm chỉ mới được sử dụng một lần duy nhất.
--   Thông tin hiển thị bao gồm ma_hop_dong, ten_loai_dich_vu, ten_dich_vu_di_kem,
--   so_lan_su_dung (được tính dựa trên việc count các ma_dich_vu_di_kem).

select contract.contract_id, type_service.type_name_service,accompanied_service.name_service, 
count(accompanied_service.service_code) as so_lan_su_dung from contract
join detail_contract on detail_contract.contract_id = contract.contract_id
join accompanied_service on accompanied_service.service_code= detail_contract.service_code
join service on service.service_id = contract.service_id
join type_service on type_service.type_service_id = service.type_service_id
group by accompanied_service.service_code
having count(accompanied_service.service_code) =1
order by contract.contract_id ;




