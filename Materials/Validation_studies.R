rm(list=ls(all=TRUE))  ##clear
setwd("/Users/simon/Library/CloudStorage/OneDrive-TheChineseUniversityofHongKong/Project/LLM/R_package/Validation Experiment/")
library(lme4)
library(openxlsx)
library(ggplot2)
library(Rmisc)

#### Load and code data
# Coding of variables
df_all <- read.xlsx("Validation_data2.xlsx",1)
df_all$Coding2[df_all$Coding=="Female"]<-1
df_all$Coding2[df_all$Coding=="Male"]<-0
df_all$cCondition[df_all$Condition=="Open syllable"]<-0.5
df_all$cCondition[df_all$Condition=="Close syllable"]<--0.5
df_all_raw <- df_all
### MTPR
# Select target data
df_MTPR <- subset(df_all,Coding!="Other"&Experiment=="MTPR")

# Create factor
df_MTPR$Run<-factor(df_MTPR$Run)
df_MTPR$ItemID<-factor(df_MTPR$ItemID)
df_MTPR$Condition<-factor(df_MTPR$Condition)
df_MTPR$Coding<-factor(df_MTPR$Coding)
df_MTPR$Coding<-relevel(df_MTPR$Coding,ref="Male")

### Descriptive
df_MTPR_gpt3.5 <- subset(df_MTPR,df_MTPR$Group=="GPT3.5")
df_MTPR_llama2_7b <- subset(df_MTPR,df_MTPR$Group=="Llama2_7B")
df_MTPR_vicuna <- subset(df_MTPR, df_MTPR$Group == "Vicuna_1.5_13B")


# aggregate(Coding2~Condition,df_MTPR_gpt4,mean)
# #        Condition   Coding2
# # 1 Close syllable 0.1714379
# # 2  Open syllable 0.6927789

# aggregate(Coding2~Condition,df_MTPR_llama2_70b,mean)
# #        Condition   Coding2
# # 1 Close syllable 0.4549451
# # 2  Open syllable 0.8300408



### Main main analysis
## GPT3.5
aggregate(Coding2~Condition,df_MTPR_gpt3.5,mean)
#        Condition   Coding2
# 1 Close syllable 0.3449045
# 2  Open syllable 0.6397221

mtpr.gpt3.5.0<-glmer(Coding~cCondition+(1|ItemID)+(1|Run),df_MTPR_gpt3.5,family="binomial",control=glmerControl(optimizer="bobyqa",optCtrl=list(maxfun=1e6)))

mtpr.gpt3.5.1<-glmer(Coding~cCondition+(cCondition+1|ItemID)+(1|Run),df_MTPR_gpt3.5,family="binomial",control=glmerControl(optimizer="bobyqa",optCtrl=list(maxfun=1e6)))

mtpr.gpt3.5.2<-glmer(Coding~cCondition+(1|ItemID)+(cCondition+1|Run),df_MTPR_gpt3.5,family="binomial",control=glmerControl(optimizer="bobyqa",optCtrl=list(maxfun=1e6)))

# Model comparison to determine the random effect
anova(mtpr.gpt3.5.0,mtpr.gpt3.5.1) #y
anova(mtpr.gpt3.5.0,mtpr.gpt3.5.2)

# Final model
mtpr.gpt3.5<-mtpr.gpt3.5.1
summary(mtpr.gpt3.5)
#             Estimate Std. Error z value Pr(>|z|)    
# (Intercept)   0.1158     0.3728   0.311    0.756    
# cCondition    2.1855     0.5585   3.913 9.11e-05 ***


# Llama2_7b
aggregate(Coding2~Condition,df_MTPR_llama2_7b,mean)
#        Condition   Coding2
# 1 Close syllable 0.1097240
# 2  Open syllable 0.3756162

mtpr.llama2_7b.0<-glmer(Coding~cCondition+(1|ItemID)+(1|Run),df_MTPR_llama2_7b,family="binomial",control=glmerControl(optimizer="bobyqa",optCtrl=list(maxfun=1e6)))

mtpr.llama2_7b.1<-glmer(Coding~cCondition+(cCondition+1|ItemID)+(1|Run),df_MTPR_llama2_7b,family="binomial",control=glmerControl(optimizer="bobyqa",optCtrl=list(maxfun=1e6)))

mtpr.llama2_7b.2<-glmer(Coding~cCondition+(1|ItemID)+(cCondition+1|Run),df_MTPR_llama2_7b,family="binomial",control=glmerControl(optimizer="bobyqa",optCtrl=list(maxfun=1e6)))

# Model comparison to determine the random effect
anova(mtpr.llama2_7b.0,mtpr.llama2_7b.1) #y
anova(mtpr.llama2_7b.0,mtpr.llama2_7b.2) 

# Final model
mtpr.llama2_7b<-mtpr.llama2_7b.1
summary(mtpr.llama2_7b)
#             Estimate Std. Error z value Pr(>|z|)    
# (Intercept)  -2.0753     0.5113  -4.059 4.94e-05 ***
# cCondition    2.3808     0.5046   4.718 2.38e-06 ***


# Vicuna
aggregate(Coding2~Condition,df_MTPR_vicuna,mean)
#        Condition   Coding2
# 1 Close syllable 0.2111189
# 2  Open syllable 0.4226106

mtpr.vicuna.0<-glmer(Coding~cCondition+(1|ItemID)+(1|Run),df_MTPR_vicuna,family="binomial",control=glmerControl(optimizer="bobyqa",optCtrl=list(maxfun=1e6)))

mtpr.vicuna.1<-glmer(Coding~cCondition+(cCondition+1|ItemID)+(1|Run),df_MTPR_vicuna,family="binomial",control=glmerControl(optimizer="bobyqa",optCtrl=list(maxfun=1e6)))

mtpr.vicuna.2<-glmer(Coding~cCondition+(1|ItemID)+(cCondition+1|Run),df_MTPR_vicuna,family="binomial",control=glmerControl(optimizer="bobyqa",optCtrl=list(maxfun=1e6)))

# Model comparison to determine the random effect
anova(mtpr.vicuna.0,mtpr.vicuna.1) #y
anova(mtpr.vicuna.0,mtpr.vicuna.2) #y

# Final model
mtpr.vicuna<-glmer(Coding~cCondition+(cCondition+1|ItemID)+(cCondition+1|Run),df_MTPR_vicuna,family="binomial",control=glmerControl(optimizer="bobyqa",optCtrl=list(maxfun=1e6)))
summary(mtpr.vicuna)
#             Estimate Std. Error z value Pr(>|z|)    
# (Intercept)  -1.1158     0.3172  -3.518 0.000434 ***
# cCondition    1.3391     0.2111   6.342 2.26e-10 ***

## OTPR Analysis
# Select target data
df_OTPR <- subset(df_all,df_all$Coding!="Other"&df_all$Experiment=="OTPR")

# Create factor
df_OTPR$Run<-factor(df_OTPR$Run)
df_OTPR$ItemID<-factor(df_OTPR$ItemID)
df_OTPR$Condition<-factor(df_OTPR$Condition)
df_OTPR$Coding<-factor(df_OTPR$Coding)
df_OTPR$Coding<-relevel(df_OTPR$Coding,ref="Male")
summary(df_OTPR)

### Descriptives
df_OTPR_gpt3.5 <- subset(df_OTPR,df_OTPR$Group=="GPT3.5")
# df_OTPR_gpt4 <- subset(df_OTPR,df_OTPR$Group=="GPT4")
# df_OTPR_llama2_70b <- subset(df_OTPR,df_OTPR$Group=="Llama2_70B")
df_OTPR_llama2_7b <- subset(df_OTPR,df_OTPR$Group=="Llama2_7B")
df_OTPR_vicuna <- subset(df_OTPR, df_OTPR$Group == "Vicuna_1.5_13B")


### Main main analysis
## GPT3.5
aggregate(Coding2~Condition,df_OTPR_gpt3.5,mean)
#        Condition    Coding2
# 1 Close syllable 0.07816456
# 2  Open syllable 0.67553866

otpr.gpt3.5.0<-glmer(Coding~cCondition+(1|ItemID),df_OTPR_gpt3.5,family="binomial",control=glmerControl(optimizer="bobyqa",optCtrl=list(maxfun=1e6)))

otpr.gpt3.5.1<-glmer(Coding~cCondition+(cCondition+1|ItemID),df_OTPR_gpt3.5,family="binomial",control=glmerControl(optimizer="bobyqa",optCtrl=list(maxfun=1e6)))


# Model comparison to determine the random effect
anova(otpr.gpt3.5.0,otpr.gpt3.5.1) #y

# Final model
otpr.gpt3.5<-otpr.gpt3.5.1
summary(otpr.gpt3.5)
#             Estimate Std. Error z value Pr(>|z|)    
# (Intercept)  -1.3928     0.5992  -2.324   0.0201 *  
# cCondition    6.5401     1.5056   4.344  1.4e-05 ***

# Llama2_7b
aggregate(Coding2~Condition,df_OTPR_llama2_7b,mean)
#        Condition   Coding2
# 1 Close syllable 0.1183824
# 2  Open syllable 0.6257353

otpr.llama2_7b.0<-glmer(Coding~cCondition+(1|ItemID),df_OTPR_llama2_7b,family="binomial",control=glmerControl(optimizer="bobyqa",optCtrl=list(maxfun=1e6)))

otpr.llama2_7b.1<-glmer(Coding~cCondition+(cCondition+1|ItemID),df_OTPR_llama2_7b,family="binomial",control=glmerControl(optimizer="bobyqa",optCtrl=list(maxfun=1e6)))


# Model comparison to determine the random effect
anova(otpr.llama2_7b.0,otpr.llama2_7b.1) #y

# Final model
otpr.llama2_7b<-otpr.llama2_7b.1
summary(otpr.llama2_7b)
#             Estimate Std. Error z value Pr(>|z|)    
# (Intercept)  -0.8856     0.9147  -0.968    0.333    
# cCondition    6.5439     1.2094   5.411 6.27e-08 ***

# Vicuna
aggregate(Coding2~Condition,df_OTPR_vicuna,mean)
#        Condition    Coding2
# 1 Close syllable 0.06944932
# 2  Open syllable 0.35742397

otpr.vicuna.0<-glmer(Coding~cCondition+(1|ItemID),df_OTPR_vicuna,family="binomial",control=glmerControl(optimizer="bobyqa",optCtrl=list(maxfun=1e6)))

otpr.vicuna.1<-glmer(Coding~cCondition+(cCondition+1|ItemID),df_OTPR_vicuna,family="binomial",control=glmerControl(optimizer="bobyqa",optCtrl=list(maxfun=1e6)))

# Model comparison to determine the random effect
anova(otpr.vicuna.0,otpr.vicuna.1) #y

# Final model
otpr.vicuna<-otpr.vicuna.1
summary(otpr.vicuna)
#             Estimate Std. Error z value Pr(>|z|)    
# (Intercept)  -2.3624     0.4676  -5.052 4.36e-07 ***
# cCondition    3.0200     0.4971   6.075 1.24e-09 ***

### Probability analysis
# Select target data
df_PROB <- subset(df_all,df_all$Experiment=="Probability")
df_PROB$Difference<- df_PROB$`Female%`-df_PROB$`Male%`
# Create factor
df_PROB$Run<-factor(df_PROB$Run)
df_PROB$ItemID<-factor(df_PROB$ItemID)
df_PROB$Condition<-factor(df_PROB$Condition)
summary(df_PROB)

# Descriptives
df_PROB_gpt3.5 <- subset(df_PROB,df_PROB$Group=="GPT3.5")
# df_PROB_gpt4 <- subset(df_PROB,df_PROB$Group=="GPT4")
# df_PROB_llama2_70b <- subset(df_PROB,df_PROB$Group=="Llama2_70B")
df_PROB_llama2_7b <- subset(df_PROB,df_PROB$Group=="Llama2_7B")
df_PROB_vicuna <- subset(df_PROB, df_PROB$Group == "Vicuna_1.5_13B")

# GPT3.5
aggregate(Difference~Condition,df_PROB_gpt3.5,mean)
#        Condition Difference
# 1 Close syllable -0.8561487
# 2  Open syllable  0.2957271

PROB.gpt3.5<-lmer(Difference~cCondition+(1|ItemID),df_PROB_gpt3.5,REML=T)

summary(PROB.gpt3.5)
#             Estimate Std. Error      df t value Pr(>|t|)    
# (Intercept)  -0.2802     0.1094 15.0000  -2.561   0.0217 *  
# cCondition    1.1519     0.2082 15.0000   5.533 5.74e-05 ***

# Llama2_7b
aggregate(Difference~Condition,df_PROB_llama2_7b,mean)
#        Condition Difference
# 1 Close syllable -0.6767824
# 2  Open syllable -0.1530598

PROB.llama2_7b<-lmer(Difference~cCondition+(1|ItemID),df_PROB_llama2_7b,REML=T)

summary(PROB.llama2_7b)
#             Estimate Std. Error       df t value Pr(>|t|)    
# (Intercept) -0.41492    0.06267 15.00000  -6.620 8.15e-06 ***
# cCondition   0.52372    0.12055 15.00000   4.345 0.000578 ***


# Vicuna
aggregate(Difference~Condition,df_PROB_vicuna,mean)
#        Condition Difference
# 1 Close syllable -0.5835469
# 2  Open syllable -0.1693409

PROB.vicuna <-lmer(Difference~cCondition+(1|ItemID),df_PROB_vicuna,REML=T)


# Final model
summary(PROB.vicuna)
#             Estimate Std. Error       df t value Pr(>|t|)    
# (Intercept) -0.37644    0.08104 15.00000  -4.645 0.000317 ***
# cCondition   0.41421    0.11559 15.00000   3.583 0.002717 ** 

### Combined analysis
df_all <- subset(df_all_raw, Coding!="Other")
df_all$cExperiment[df_all$Experiment=="OTPR"]<-0.5
df_all$cExperiment[df_all$Experiment=="MTPR"]<--0.5


# Create factor
df_all$Run<-factor(df_all$Run)
df_all$ItemID<-factor(df_all$ItemID)
df_all$Condition<-factor(df_all$Condition)
df_all$Coding<-factor(df_all$Coding)
df_all$Coding<-relevel(df_all$Coding,ref="Male")

levels(df_all$Coding)

## select data
df_all_gpt3.5 <- subset(df_all,df_all$Group=="GPT3.5")
# df_all_gpt4 <- subset(df_all,df_all$Group=="GPT4")
# df_all_llama2_70b <- subset(df_all,df_all$Group=="Llama2_70B")
df_all_llama2_7b <- subset(df_all,df_all$Group=="Llama2_7B")
df_all_vicuna <- subset(df_all, df_all$Group == "Vicuna_1.5_13B")


## GPT3.5
ca.gpt3.5.0<-glmer(Coding~cCondition*cExperiment+(1|ItemID),df_all_gpt3.5,family="binomial",control=glmerControl(optimizer="bobyqa",optCtrl=list(maxfun=1e6)))

ca.gpt3.5.1<-glmer(Coding~cCondition*cExperiment+(cCondition+1|ItemID),df_all_gpt3.5,family="binomial",control=glmerControl(optimizer="bobyqa",optCtrl=list(maxfun=1e6)))

ca.gpt3.5.2<-glmer(Coding~cCondition*cExperiment+(cExperiment+1|ItemID),df_all_gpt3.5,family="binomial",control=glmerControl(optimizer="bobyqa",optCtrl=list(maxfun=1e6)))

ca.gpt3.5.3<-glmer(Coding~cCondition*cExperiment+(cCondition:cExperiment+1|ItemID),df_all_gpt3.5,family="binomial",control=glmerControl(optimizer="bobyqa",optCtrl=list(maxfun=1e6)))


# Model comparison to determine the random effect
anova(ca.gpt3.5.0,ca.gpt3.5.1) #y
anova(ca.gpt3.5.0,ca.gpt3.5.2) #y
anova(ca.gpt3.5.0,ca.gpt3.5.3) #y

# Final model
ca.gpt3.5<- glmer(Coding~cCondition*cExperiment+(cCondition*cExperiment+1|ItemID),df_all_gpt3.5,family="binomial",control=glmerControl(optimizer="bobyqa",optCtrl=list(maxfun=1e6)))

summary(ca.gpt3.5)
#                        Estimate Std. Error z value Pr(>|z|)    
# (Intercept)             -0.5970     0.5135  -1.163  0.24498    
# cCondition               4.7970     1.1267   4.258 2.07e-05 ***
# cExperiment             -1.4136     0.4540  -3.114  0.00185 ** 
# cCondition:cExperiment   5.4351     1.3346   4.073 4.65e-05 ***


# Llama2_7b
ca.llama2_7b.0<-glmer(Coding~cCondition*cExperiment+(1|ItemID),df_all_llama2_7b,family="binomial",control=glmerControl(optimizer="bobyqa",optCtrl=list(maxfun=1e6)))

ca.llama2_7b.1<-glmer(Coding~cCondition*cExperiment+(cCondition+1|ItemID),df_all_llama2_7b,family="binomial",control=glmerControl(optimizer="bobyqa",optCtrl=list(maxfun=1e6)))

ca.llama2_7b.2<-glmer(Coding~cCondition*cExperiment+(cExperiment+1|ItemID),df_all_llama2_7b,family="binomial",control=glmerControl(optimizer="bobyqa",optCtrl=list(maxfun=1e6)))

ca.llama2_7b.3<-glmer(Coding~cCondition*cExperiment+(cCondition:cExperiment+1|ItemID),df_all_llama2_7b,family="binomial",control=glmerControl(optimizer="bobyqa",optCtrl=list(maxfun=1e6)))


# Model comparison to determine the random effect
anova(ca.llama2_7b.0,ca.llama2_7b.1)#y
anova(ca.llama2_7b.0,ca.llama2_7b.2)#y
anova(ca.llama2_7b.0,ca.llama2_7b.3)#y

# Final model
ca.llama2_7b<-glmer(Coding~cCondition*cExperiment+(cCondition*cExperiment+1|ItemID),df_all_llama2_7b,family="binomial",control=glmerControl(optimizer="bobyqa",optCtrl=list(maxfun=1e6)))

summary(ca.llama2_7b)
#                        Estimate Std. Error z value Pr(>|z|)    
# (Intercept)             -1.5205     0.6366  -2.388   0.0169 *  
# cCondition               4.3180     0.7155   6.035 1.59e-09 ***
# cExperiment              0.7050     0.4988   1.413   0.1576    
# cCondition:cExperiment   4.2906     0.7744   5.541 3.01e-08 ***


# Vicuna
ca.vicuna.0<-glmer(Coding~cCondition*cExperiment+(1|ItemID),df_all_vicuna,family="binomial",control=glmerControl(optimizer="bobyqa",optCtrl=list(maxfun=1e6)))

ca.vicuna.1<-glmer(Coding~cCondition*cExperiment+(cCondition+1|ItemID),df_all_vicuna,family="binomial",control=glmerControl(optimizer="bobyqa",optCtrl=list(maxfun=1e6)))

ca.vicuna.2<-glmer(Coding~cCondition*cExperiment+(cExperiment+1|ItemID),df_all_vicuna,family="binomial",control=glmerControl(optimizer="bobyqa",optCtrl=list(maxfun=1e6)))

ca.vicuna.3<-glmer(Coding~cCondition*cExperiment+(cCondition:cExperiment+1|ItemID),df_all_vicuna,family="binomial",control=glmerControl(optimizer="bobyqa",optCtrl=list(maxfun=1e6)))

# Model comparison to determine the random effect
anova(ca.vicuna.0,ca.vicuna.1) #y
anova(ca.vicuna.0,ca.vicuna.2) #y
anova(ca.vicuna.0,ca.vicuna.3) #y

# Final model
ca.vicuna<-glmer(Coding~cCondition*cExperiment+(cCondition*cExperiment+1|ItemID),df_all_vicuna,family="binomial",control=glmerControl(optimizer="bobyqa",optCtrl=list(maxfun=1e6)))

summary(ca.vicuna)
#                        Estimate Std. Error z value Pr(>|z|)    
# (Intercept)             -1.6768     0.3590  -4.670 3.01e-06 ***
# cCondition               2.1083     0.3366   6.264 3.75e-10 ***
# cExperiment             -1.3521     0.2665  -5.073 3.91e-07 ***
# cCondition:cExperiment   1.8318     0.3734   4.906 9.31e-07 ***

## Correlation analysis with Probality and OTPR
# Subset the data

df_all_OTPR <- subset(df_all, Experiment == "OTPR" & Group != "Llama2_70B"& Group != "GPT4")
df_all_Prob <- subset(df_all, Experiment == "Probability")

# Create binary variables for Male% and Female%
df_all_OTPR$`Female%` <- ifelse(df_all_OTPR$Coding == "Female", 1, 0)
df_all_OTPR$`Male%` <- ifelse(df_all_OTPR$Coding == "Male", 1, 0)

# Calculate summary statistics
df_all_OTPR.prob <- cbind(
  summarySE(df_all_OTPR, measurevar = 'Female%', groupvars = c('Condition', 'Group', 'ItemID'), na.rm = TRUE),
  summarySE(df_all_OTPR, measurevar = 'Male%', groupvars = c('Condition', 'Group', 'ItemID'), na.rm = TRUE)
)

# Order the data
df_all_OTPR.prob <- df_all_OTPR.prob[order(df_all_OTPR.prob$Group, df_all_OTPR.prob$ItemID,df_all_OTPR.prob$Condition), ]
df_all_Prob <- df_all_Prob[order(df_all_Prob$Group, df_all_Prob$ItemID,df_all_Prob$Condition), ]

# Calculate correlation
correlation_results <- data.frame(Group = character(), Correlation = numeric())
groups <- unique(df_all_OTPR.prob$Group)

for (group in groups) {
  subset_female_OTPR <- subset(df_all_OTPR.prob, Group == group)$`Female%`
  subset_female_Prob <- subset(df_all_Prob, Group == group)$`Female%`
  group_data1 <- subset_female_OTPR[seq(2, length(subset_female_OTPR), by = 2)]- subset_female_OTPR[seq(1, length(subset_female_OTPR), by = 2)]
  group_data2 <- subset_female_Prob[seq(2, length(subset_female_Prob), by = 2)] - subset_female_Prob[seq(1, length(subset_female_Prob), by = 2)]
  correlation_test <- cor.test(group_data1, group_data2)
  correlation <- correlation_test$estimate
  t_value <- correlation_test$statistic
  p_value <- correlation_test$p.value
  correlation_results <- rbind(correlation_results, data.frame(Group = group, Correlation = correlation, T_value = t_value, P_value = p_value))
}

# Print the results
print(correlation_results)
#            Group Correlation
# 1         GPT3.5   0.5906141
# 2      Llama2_7B   0.4273369
# 3 Vicuna_1.5_13B   0.6231444

MAS <- c(69, 70, 71, 73, 77, 78, 82, 83, 85, 88, 93, 96)
sd <- sd(MAS)
xbar <- mean(MAS)
n <- length(MAS)
alpha = 0.05
t <- qt(1-alpha/2, df=n-1) 
# n<30 use T distribution for inference instead of normal distribution. 
tCI95p<- c(xbar-t*sd/sqrt(n), xbar+t*sd/sqrt(n))
tCI95p

# [1] 74.70503 86.12830

t.test(MAS,mu=xbar,)
 # 74.70503 86.12830

### plot figures

# Load and code data

df_all <- read.xlsx("Validation_data2.xlsx", 1)
df_all$cCondition[df_all$Condition == "Close syllable"] <- -0.5
df_all$cCondition[df_all$Condition == "Open syllable"] <- 0.5
df_all$Code2[df_all$Coding == "Female"] <- 1
df_all$Code2[df_all$Coding == "Male"] <- 0

## select data
df_MTPR <- subset(df_all,Coding!="Other"&Experiment=="MTPR"&Group!= "Llama2_70B"&Group!= "GPT4")

df_OTPR <- subset(df_all,Coding!="Other"&Experiment=="OTPR"&Group!= "Llama2_70B"&Group!= "GPT4")

df_PROB <- subset(df_all,Experiment=="Probability"&Group!= "Llama2_70B"&Group!= "GPT4")

## Factor
df_MTPR$Run <- factor(df_MTPR$Run)
df_MTPR$Condition <- factor(df_MTPR$Condition)
levels(df_MTPR$Condition)

df_MTPRR.S <- summarySE(df_MTPR, measurevar = 'Code2',groupvars = c("Condition","Group"))

MTPR_fig <- ggplot(data=df_MTPRR.S, aes(x=factor(Condition), y=Code2,fill=Condition))+
  theme_bw() +
  geom_bar(stat = "identity",position = position_dodge())+
  geom_errorbar(aes(ymin=Code2-ci, ymax=Code2+ci), position=position_dodge(width=0.9),width=0.3)+
  labs(y= "Prop. feminine responses", x = "Name")+
  theme(text = element_text(size=15),legend.position="none")+
  geom_point(x = "Close syllable", y = 0.32, pch = 23, cex = 5, fill = "black") +
  geom_point(x = "Open syllable", y = 0.74, pch = 23, cex = 5, fill = "black") +
  ylim(0, 1)+
  facet_wrap(~Group,nrow = 1)

MTPR_fig


## Factorize 
df_OTPR$Run <- factor(df_OTPR$Run)
df_OTPR$Condition <- factor(df_OTPR$Condition)
levels(df_OTPR$Condition)



df_OTPRR.S <- summarySE(df_OTPR, measurevar = 'Code2',groupvars = c("Condition","Group"))

OTPR_fig <- ggplot(data=df_OTPRR.S, aes(x=factor(Condition), y=Code2,fill=Condition))+
  theme_bw() +
  geom_bar(stat = "identity",position = position_dodge())+
  geom_errorbar(aes(ymin=Code2-ci, ymax=Code2+ci), position=position_dodge(width=0.9),width=0.3)+
  labs(y= "Prop. feminine responses", x = "Name")+
  theme(text = element_text(size=15),legend.position="none")+
  geom_point(x = "Close syllable", y = 0.32, pch = 23, cex = 5, fill = "black") +
  geom_point(x = "Open syllable", y = 0.74, pch = 23, cex = 5, fill = "black") +
  ylim(0, 1)+
  facet_wrap(~Group,nrow = 1)

OTPR_fig


## Probablity
df_PROB$Run <- factor(df_PROB$Run)
df_PROB$Condition <- factor(df_PROB$Condition)
levels(df_PROB$Condition)

df_PROBR.S <- summarySE(df_PROB, measurevar = 'Female%',groupvars = c("Condition","Group"))

PROB_fig <- ggplot(data=df_PROBR.S, aes(x=factor(Condition), y=`Female%`,fill=Condition))+
  theme_bw() +
  geom_bar(stat = "identity",position = position_dodge())+
  geom_errorbar(aes(ymin=`Female%`-ci, ymax=`Female%`+ci), position=position_dodge(width=0.9),width=0.3)+
  labs(y= "Probability of feminine pronoun", x = "Name")+
  theme(text = element_text(size=15),legend.position="none")+
  geom_point(x = "Close syllable", y = 0.32, pch = 23, cex = 5, fill = "black") +
  geom_point(x = "Open syllable", y = 0.74, pch = 23, cex = 5, fill = "black") +
  ylim(0, 1)+
  facet_wrap(~Group,nrow = 1)

PROB_fig


## combinded analysis
df_all$Run <- factor(df_all$Run)
df_all$Condition <- factor(df_all$Condition)
levels(df_all$Condition)

df_all <- summarySE(df_all, measurevar = 'Code2',groupvars = c("Condition","Group"),na.rm = TRUE)

Com_fig <- ggplot(data=df_all, aes(x=factor(Condition), y=Code2,fill=Condition))+
  theme_bw() +
  geom_bar(stat = "identity",position = position_dodge())+
  geom_errorbar(aes(ymin=Code2-ci, ymax=Code2+ci), position=position_dodge(width=0.9),width=0.3)+
  labs(y= "Prop. feminine responses", x = "Name")+
  theme(text = element_text(size=15),legend.position="none")+
  geom_point(x = "Close syllable", y = 0.32, pch = 23, cex = 5, fill = "black") +
  geom_point(x = "Open syllable", y = 0.74, pch = 23, cex = 5, fill = "black") +
  ylim(0, 1)+
  facet_wrap(~Group,nrow = 1)
Com_fig

MTPR_fCom_figig