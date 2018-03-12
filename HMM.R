library(depmixS4)
library(ggplot2)args <- commandArgs(TRUE)

### Read data: tabulated file
# 3 arguments
# 1: input RT file
# 2: number of hidden State
# 3: output
RT_data_50K = read.delim(args[1], stringsAsFactors=FALSE)

#runningData = data.frame(data4)
runningData = data.frame(RT_data_50K)
##multivarite HMM
sink (paste("C:\\Users\\apoulet\\Desktop\\resuHMM6_71217.txt"))
mod2 <- depmix(
				list(
ESC_BG01_R1~1,ESC_BG02_AVG~1,ESC_Cyt49_AVG~1,ESC_H1_AVG~1,ESC_H7_R1~1,ESC_H9_AVG~1,iPS4_AVG~1,iPS5_AVG~1,
Mesendoderm_BG02_AVG~1,DE_BG02_AVG~1,DE_Cyt49_AVG~1,Liver_d8_Cyt49_R1~1,Liver_d5_Cyt49_R1~1,Liver_d16_Cyt49_AVG~1,
PE_d5_Cyt49_AVG~1,PE_d8_Cyt49_R1~1,PE_d12_Cyt49_AVG~1,
NC_Cyt49_AVG~1,NC_H9_AVG~1,LPM_H9_AVG~1,Splanc_BG02_AVG~1,Splanc_Cyt49_AVG~1,Splanc_H9_AVG~1,Mesothel_Cyt49_AVG~1,
Mesothel_H9_AVG~1,SM_BG02_AVG~1,SM_H9_AVG~1,Myoblast_AVG~1,Fibroblast_IMR90_R1~1,MSC_d17_H9_AVG~1,NPC_BG01_AVG~1,
NPC_H9_R1~1,MPB_CD34_R1~1,MPB_EpoD3_R1~1,MPB_EpoD5_R1~1,MPB_MyeD3_R1~1,MPB_MyeD5_R1~1,C0202_Lymph_AVG~1,GM06990_AVG~1,
GM06999_AVG~1,NC_NC_R2~1,Tlymph_R1~1
		),
				data = runningData,
				nstates=args[2], 
				family=list(
				gaussian(),gaussian(),gaussian(),gaussian(),gaussian(),gaussian(),gaussian(),gaussian(),gaussian(),gaussian(),gaussian(),gaussian(),gaussian(),gaussian(),gaussian(),gaussian(),gaussian(),gaussian(),gaussian(),gaussian(),gaussian(),gaussian(),gaussian(),gaussian(),gaussian(),gaussian(),gaussian(),gaussian(),gaussian(),gaussian(),gaussian(),gaussian(),gaussian(),gaussian(),gaussian(),gaussian(),gaussian(),gaussian(),gaussian(),gaussian(),gaussian(),gaussian())
				)

fm2 <- fit(mod2)
summary(fm2)
fm2

resu = fm2@posterior
write.table(resu, file = args[3])

sink()
