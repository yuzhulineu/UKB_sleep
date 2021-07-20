datamedia1=readMat('/share/inspurStorage/home1/liyz/Project/acc/meidation_int2_lavaan/mediationpath1_int2.mat')
datapath1<-data.frame(matrix(unlist(datamedia1),nrow=12302,byrow=F))

datamedia2=readMat('/share/inspurStorage/home1/liyz/Project/acc/meidation_int2_lavaan/mediationpath2_int2.mat')
datapath2<-data.frame(matrix(unlist(datamedia2),nrow=12302,byrow=F))

datamedia3=readMat('/share/inspurStorage/home1/liyz/Project/acc/meidation_int2_lavaan/mediationpath3_int2.mat')
datapath3<-data.frame(matrix(unlist(datamedia3),nrow=12302,byrow=F))


colnames(datapath1)<-c("PRS","Sleep","BrainVolume","Depression")
colnames(datapath2)<-c("PRS","BrainVolume","Depression")
colnames(datapath3)<-c("PRS","Sleep","Depression")
library(lavaan)
model0=
  "
Depression ~ z*PRS
"
fit0_dep<-sem(model0,data = datapath1, se="boot", bootstrap = 10000)
oriexp_dep<-summary(fit0_dep,standardized=T)

model1=
  "

Sleep ~ a*PRS
BrainVolume ~ b*Sleep
Depression ~ c*BrainVolume+a1*PRS

ie :=a*b*c
de :=a1
"

fit1_dep<-sem(model1,data = datapath1, se="boot", bootstrap = 10000)
mediationpath1_dep<-summary(fit1_dep,standardized=T)

model2=
  "
   BrainVolume ~ a1*PRS
    Depression ~ b1*BrainVolume + b2*PRS

ie := a1*b1
de := b2
     
"

fit2_dep<-sem(model2,data = datapath2, se="boot", bootstrap = 10000)
fit_summary2_dep<-summary(fit2_dep,standardized=T)

model3=
  "
   Sleep ~ a2*PRS
    Depression ~ b2*Sleep + b3*PRS

ie := a2*b2
de := b3
"

fit3_dep<-sem(model3,data = datapath3, se="boot", bootstrap = 10000)
fit_summary3_dep<-summary(fit3_dep,standardized=T)