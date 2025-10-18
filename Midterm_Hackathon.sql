/*
`polar-winter-343402.hometest.hackathon_phone_sales` a
`polar-winter-343402.hometest.hackathon_accessories_sales` b
2 table mapping bằng transactionID

*/

-- 1. Có bao nhiêu đơn hàng trong từng tháng?
select 
  format_date('%Y %m',parse_date('%Y %m %d',DatePurchase)) month
  ,count(distinct TransactionID) so_don_hang
from `homew-473402.practise.Hackathon_Phone_Sales`
group by 1
order by 1;


-- 2. Có bao nhiêu khách hàng mua hàng trong từng tháng?
select 
  format_date('%Y %m',parse_date('%Y %m %d',DatePurchase)) month
  ,count(distinct CustomerCode) so_khach_hang
from `homew-473402.practise.Hackathon_Phone_Sales`
group by 1
order by 1;

-- 3. Nhóm khách hàng Nam và Nữ thích điện thoại của hãng nào nhất, lấy top 3? (dựa vào đơn hàng)

--đếm số lượng bán ra của từng hãng (dựa trên field Unit) theo giới tính
with 
raw_data as (
  select 
    SexType
    ,ProductBrand
    ,count(TransactionID) so_luong
  from `homew-473402.practise.Hackathon_Phone_Sales`
  group by 1,2
  order by 1,2,3
)

,ranking_so_luong as (
select
  SexType
  ,ProductBrand
  ,so_luong
  ,dense_rank() over( partition by SexType order by so_luong desc) rk
from raw_data
order by 1,4
)

select
  SexType
  ,ProductBrand
  ,so_luong
  ,rk
from ranking_so_luong
where rk <=3
order by 1,4
;

-- 4. Nhóm tuổi nào mua nhiều nhất, Nhóm tuổi nào mang lại doanh thu nhiều nhất? Bạn có thể rút ra kết luận gì không
--tính lượng mua của theo nhóm tuổi (sum unit)
select 
    YearOldRange
    ,sum(Unit) so_luong
from `homew-473402.practise.Hackathon_Phone_Sales`
group by 1
order by 2
;
--nhóm tuổi 26-30 mua nhiều nhất (57045), nhóm thứ 2 là 31-35 tuổi (20866)
select 
    YearOldRange
    ,sum(SalesValue) doanh_thu
from `homew-473402.practise.Hackathon_Phone_Sales`
group by 1
order by 2
;
--nhóm tuổi 26-30 mang lại DT nhiều nhất (250380794600), nhóm thứ 2 là 31-35 tuổi (94639260500)

-- 5. Top 3 sản phẩm mang lại doanh thu cao nhất của từng tháng? Đưa ra insight cho business nếu có

--lấy doanh thu theo từng tháng, từng sp
with 
raw_data as ( ---lấy doanh thu theo từng tháng, từng productname
  select 
    format_date('%Y %m',parse_date('%Y %m %d',DatePurchase)) month
    ,ProductName
    ,sum(SalesValue) doanh_thu
  from `homew-473402.practise.Hackathon_Phone_Sales`
  group by 1,2
  order by 1,3 desc
)
--ranking theo tháng
,ranking_doanhthu as (
  select
    month
    ,ProductName
    ,doanh_thu
    ,dense_rank() over(partition by month order by doanh_thu desc) rk
  from raw_data
)

select 
*
from ranking_doanhthu
where rk <= 3
order by month, rk
;

-- 6. Nhóm khách hàng 26-30 yêu thích hãng nào, họ có sẵn sàng chi thêm để mua phụ kiện không
--lấy số lượng bán của nhóm khách 26-30 theo từng hãng
with 
raw_data as (
  select
    YearOldRange
    ,ProductBrand
    ,count(TransactionID) so_luong
  from `homew-473402.practise.Hackathon_Phone_Sales`
  where YearOldRange = '26-30'
  group by 1,2
  order by 3 desc
)

select
  YearOldRange
  ,ProductBrand
  ,so_luong
  ,dense_rank() over(order by so_luong desc) rk
from raw_data
order by rk
;

--7.Nhóm khách hàng 26-30 có sẵn sàng mua thêm để mua phụ kiện, bảo hiểm không?
--đế xem được nhóm khách 26-30 có sẵn sàng chi thêm để mua phụ không, thì mình sẽ
--combine bảng phone và accessories
--check xem có bao nhiêu người mua phụ kiện
with 
raw_data as (
  select
    a.TransactionID
    ,a.YearOldRange
    ,a.ProductName
    ,b.Accessories_name
    ,b.Accessories_subname
    ,b.SalesValue
  from    `homew-473402.practise.Hackathon_Phone_Sales` a
  left join `homew-473402.practise.Hackathon_Accessories_Sales` b
  using(transactionID)
  order by 1
)
--sau đó mình đếm số Accessories_name/total để ra được tỉ lệ khách mua phụ kiện

select
  YearOldRange
 ,count(Accessories_name) accessories_sale
 ,count(*) as total
 ,count(Accessories_name)/count(*) ti_le_mua_phu_kien
from raw_data
group by 1
order by 1;
;


-- 8. Hành vi của nhóm khách hàng trên 40 là gì (hãng điện thoại, mẫu điện thoại, giá cả, phụ kiện...)
with 
raw_data as (
  select
    a.TransactionID
    ,a.YearOldRange
    ,a.ProductName
    ,a.ProductBrand
    ,a.SalesValue SalesValue_phone
    ,a.Color
    ,b.Accessories_name
    ,b.Accessories_subname
    ,b.SalesValue  SalesValue_phukien
  from    `homew-473402.practise.Hackathon_Phone_Sales` a
  left join `homew-473402.practise.Hackathon_Accessories_Sales` b
  using(transactionID)
  
  order by 1
)

select 
  ProductBrand
  ,count(*) as total_order
  ,avg(SalesValue_phone) avg_SalesValue_phone
  ,count(Accessories_name) accessories_sale_cnt
  ,count(Accessories_name)/count(*) ti_le_mua_phu_kien
from raw_data
group by 1
;

-- 9. Nhóm tuổi nào có hành vi mua trả góp nhiều nhất? Hãng điện thoại được mua trả góp nhiều nhất?
--nhóm tuổi nào có hành vi mua trả góp nhiều nhất
Select
  YearOldRange
  ,count(Bank) installments
  ,count(*) total_orders
  ,count(Bank)/count(*) ti_le_installments
from `homew-473402.practise.Hackathon_Phone_Sales`
group by 1
order by 4 desc
;


--10. Hãng nào được mua trả góp nhiều nhất
Select
  ProductBrand
  ,count(Bank) installments
  ,count(*) total_orders
  ,count(Bank)/count(*) ti_le_installments
from `homew-473402.practise.Hackathon_Phone_Sales`
group by 1
order by 4 desc
;
