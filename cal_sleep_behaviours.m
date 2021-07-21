load sleepnewall
subjid=str2double(cellstr(table2array(sleepnewall(:,1))));
sleep0=str2double(cellstr(table2array(sleepnewall(:,2))));
sleepreport0=sleep0(sleep0>0);
id_sleep0=subjid(sleep0>0); 


load cov_ukb_int0
cov_ukb0=str2double(cellstr(table2array(cov_ukb_int0(:,2:end))));
cov_id0=str2double(cellstr(table2array(cov_ukb_int0(:,1))));

load('/share/inspurStorage/home1/liyz/Project/acc/mental/behaviourall.mat')
load('/share/inspurStorage/home1/liyz/Project/acc/mental/measure_id.mat')
for bb=1:size(behaviourall,2)
       beha=behaviourall(:,bb);
       beha_overall=beha(~isnan(beha));
       id_be=id_behaviour(~isnan(beha));
       
       final_id=intersect_multi({cov_id0;id_sleep0;id_be});
       [~,index]=intersect(cov_id0,final_id);
       cov_1=cov_ukb0(index,:);
       cov_final1=nan(size(cov_1));
       for kk=1:size(cov_1,2)
           cov1=cov_1(:,kk);
           cov1(isnan(cov1))=nanmean(cov1);
           cov_final1(:,kk)=cov1;
       end
       
       [~,index]=intersect(id_sleep0,final_id);
       sleepmeasure_final=sleepreport0(index,:);
       
       [~,index]=intersect(id_be,final_id);
       beha_final=beha_overall(index);
       
       Covariate = cov_final1;
       
       [F_value_mentalsleep(bb,:), P_value_mentalsleep(bb,:)] = BWAS_Fregression(beha_final',[sleepmeasure_final,sleepmeasure_final.^2],Covariate);
end

result_sleepmental=table(F_value_mentalsleep,P_value_mentalsleep);
result_sleepmental.Variable (1:10)= {'alcohol','anxiety','cannabis','depression','mania','mentaldistress','psychoExp','selfharm','trauma','wellbeing'};

%%
load sleepnewall
subjid=str2double(cellstr(table2array(sleepnewall(:,1))));
sleep0=str2double(cellstr(table2array(sleepnewall(:,2))));
sleepreport0=sleep0(sleep0>0);
id_sleep0=subjid(sleep0>0); 

load cov_ukb_int0
cov_ukb0=str2double(cellstr(table2array(cov_ukb_int0(:,2:end))));
cov_id0=str2double(cellstr(table2array(cov_ukb_int0(:,1))));

load('Cognitive_func_fl.mat')
id_cog=Cognitive_func{1};
for bb=1:size(Cognitive_func,1)-2
beha=Cognitive_func{bb+1}(:,1);
beha_overall=beha(~isnan(beha));
id_be=id_cog(~isnan(beha));
if size(id_be,1)>200000
kk=randi([1,size(id_be,1)],1,250000);
beha_overall=beha_overall(kk);
id_be=id_be(kk);
end
final_id=intersect_multi({cov_id0;id_sleep0;id_be});
[~,index]=intersect(cov_id0,final_id);
cov_1=cov_ukb0(index,:);
cov_final1=nan(size(cov_1));
for kk=1:size(cov_1,2)
cov1=cov_1(:,kk);
cov1(isnan(cov1))=nanmean(cov1);
cov_final1(:,kk)=cov1;
end
[~,index]=intersect(id_sleep0,final_id);
sleepmeasure_final=sleepreport0(index,:);
[~,index]=intersect(id_be,final_id);
beha_final=beha_overall(index);
if bb==5
    beha_final(beha_final==0) = 3;
end

Covariate = cov_final1;
[F_value_cogsleep(bb,:), P_value_cogsleep(bb,:)] = BWAS_Fregression(beha_final',[sleepmeasure_final,sleepmeasure_final.^2],Covariate);
end