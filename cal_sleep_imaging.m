load sleepnewall
subjid=str2double(cellstr(table2array( sleepnewall(:,1))));
sleep2=str2double(cellstr(table2array(sleepnewall(:,3))));
sleepreport=sleep2(sleep2>0);
sleeprepid=subjid(sleep2>0);

load cov_ukb_int2
cov_ukb2=str2double(cellstr(table2array(cov_ukb_int2(:,2:end))));
cov_id2=str2double(cellstr(table2array(cov_ukb_int2(:,1))));

load site_cov_id

load('/share/inspurStorage/home1/ISTBI_data/UKB_Freesurfer/UKB_aparc_fsstats.mat')
newimageid=table2array(UKB_aparc_Area(:,end));
newimageid=str2double(cellstr(newimageid));

final_id = intersect_multi({cov_id2;sleeprepid;newimageid;site_id});

[~,index]=intersect(cov_id2,final_id);
cov_final= cov_ukb2(index,:);
cov_final1=nan(size(cov_final));
for kk=1:size(cov_final,2)
    cov1=cov_final(:,kk);
    cov1(isnan(cov1))=nanmean(cov1);
    cov_final1(:,kk)=cov1;
end

[~, index] = intersect(site_id, final_id);
site_cov_final = site_cov(index,:);


cov_final1 = [cov_final1, site_cov_final];

[~,index]=intersect(sleeprepid,final_id);
sleepreport_final=sleepreport(index,:);

[~,index]=intersect(newimageid,final_id);
UKB_area_final=UKB_aparc_Area(index,1:end-1);
UKB_thickness_final=UKB_aparc_Thickness(index,1:end-1);
UKB_volume_final=UKB_aparc_Volume(index,1:end-1);
UKB_aparc=[UKB_area_final UKB_thickness_final UKB_volume_final];
UKB_aparc_final=double(cell2mat(table2cell(UKB_aparc)));


parfor i=1:size(UKB_aparc_final,2)
    i
    
    Covariate = cov_final1;
    [C_value_aparcsleepint2(i,:), P_value_aparcsleepint2(i,:)] = BWAS_Fregression(UKB_aparc_final(:,i)',[sleepreport_final,sleepreport_final.^2],Covariate);
end