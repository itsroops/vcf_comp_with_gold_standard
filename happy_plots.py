# Importing necessary packages
import sys
import pandas as pd
import csv
import os
import glob
import matplotlib
import matplotlib.pyplot as plt
import numpy as np


def happy_plots():
    
    # Selecting the files that need to be compared
    filepath=sys.argv[1]
    mylist = [f for f in glob.glob(filepath + "/*.summary.csv")]

    # Initializing lists for metrics calculations
    metric_recall_indel_all=[]
    metric_recall_snp_all=[]
    metric_precision_indel_all=[]
    metric_precision_snp_all=[]
    metric_f1_indel_all=[]
    metric_f1_snp_all=[]

    metric_recall_indel_pass=[]
    metric_recall_snp_pass=[]
    metric_precision_indel_pass=[]
    metric_precision_snp_pass=[]
    metric_f1_indel_pass=[]
    metric_f1_snp_pass=[]

    metric_recall_i_all=[]
    metric_recall_s_all=[]
    metric_precision_i_all=[]
    metric_precision_s_all=[]
    metric_f1_i_all=[]
    metric_f1_s_all=[]

    metric_recall_i_pass=[]
    metric_recall_s_pass=[]
    metric_precision_i_pass=[]
    metric_precision_s_pass=[]
    metric_f1_i_pass=[]
    metric_f1_s_pass=[]


    # Reading the files in the dataframe
    for i in mylist:
        file = pd.read_csv(i,sep=',', header=0)

        # Filtering the row with the type Indel and Filter All
        val1 = file.loc[(file['Type'] == "INDEL") & (file['Filter'] == "ALL")]

        # Appending its corresponding metrices accordingly
        metric_recall_indel_all.append(val1['METRIC.Recall'])
        metric_precision_indel_all.append(val1['METRIC.Precision'])
        metric_f1_indel_all.append(val1['METRIC.F1_Score'])

        # Filtering the row with the type Indel and Filter Pass
        val2 = file.loc[(file['Type'] == "INDEL") & (file['Filter'] == "PASS")]

        # Appending its corresponding metrices accordingly
        metric_recall_indel_pass.append(val2['METRIC.Recall'])
        metric_precision_indel_pass.append(val2['METRIC.Precision'])
        metric_f1_indel_pass.append(val2['METRIC.F1_Score'])

        # Filtering the row with the type SNP and Filter All
        val3 = file.loc[(file['Type'] == "SNP") & (file['Filter'] == "ALL")]

        # Appending its corresponding metrices accordingly
        metric_recall_snp_all.append(val3['METRIC.Recall'])
        metric_precision_snp_all.append(val3['METRIC.Precision'])
        metric_f1_snp_all.append(val3['METRIC.F1_Score'])

        # Filtering the row with the type SNP and Filter Pass
        val4 = file.loc[(file['Type'] == "SNP") & (file['Filter'] == "PASS")]

        # Appending its corresponding metrices accordingly
        metric_recall_snp_pass.append(val4['METRIC.Recall'])
        metric_precision_snp_pass.append(val4['METRIC.Precision'])
        metric_f1_snp_pass.append(val4['METRIC.F1_Score'])



    for i in range(0,len(metric_recall_indel_all)):

        # Extracting the actual values for the recall metric for both ALL and PASS
        metric_recall_i_all.append(metric_recall_indel_all[i].tolist()[0])
        metric_recall_s_all.append(metric_recall_snp_all[i].tolist()[0])
        metric_recall_i_pass.append(metric_recall_indel_pass[i].tolist()[0])
        metric_recall_s_pass.append(metric_recall_snp_pass[i].tolist()[0])

        # Extracting the actual values for the precision metric for both ALL and PASS
        metric_precision_i_all.append(metric_precision_indel_all[i].tolist()[0])
        metric_precision_s_all.append(metric_precision_snp_all[i].tolist()[0])
        metric_precision_i_pass.append(metric_precision_indel_pass[i].tolist()[0])
        metric_precision_s_pass.append(metric_precision_snp_pass[i].tolist()[0])

        # Extracting the actual values for the f1 score metric for both ALL and PASS
        metric_f1_i_all.append(metric_f1_indel_all[i].tolist()[0])
        metric_f1_s_all.append(metric_f1_snp_all[i].tolist()[0])
        metric_f1_i_pass.append(metric_f1_indel_pass[i].tolist()[0])
        metric_f1_s_pass.append(metric_f1_snp_pass[i].tolist()[0])

    # Initializing the label list
    labels=[]
    k = mylist[0].count("/")

    # Extracting the file names
    for i in mylist:
        p = i.split("/",k)[-1]
        p=p.split(".")[:-3]
        p=".".join(p)
        labels.append(p)


    # Setting the y-axis labels for the plots
    ylabels=['Recall','Recall','Precision','Precision', 'F1 Score','F1 Score']

    # Setting the title of the combined bar plots
    title=['Bar_Chart_for_Recall_for_Type=Indel','Bar_Chart_for_Recall_for_Type=SNP',
           'Bar_Chart_for_Precision_for_Type=Indel','Bar_Chart_for_Precision_for_Type=SNP',
           'Bar_Chart_for_F1_Score_for_Type=Indel','Bar_Chart_for_F1_Score_for_Type=SNP']


    data = [metric_recall_i_all, metric_recall_i_pass, metric_recall_s_all, metric_recall_s_pass,
            metric_precision_i_all,metric_precision_i_pass,metric_precision_s_all,metric_precision_s_pass,
            metric_f1_i_all,metric_f1_i_pass,metric_f1_s_all,metric_f1_s_pass]

    # Setting the legends for the combined bar plots
    plot_labels1=['ALL','ALL','ALL','ALL','ALL','ALL']
    plot_labels2=['PASS','PASS','PASS','PASS','PASS','PASS']

    # Setting the label locations
    x = np.arange(len(labels))  

    # Setting the width of the bars
    width = 0.35  

    k=0

    # Plotting the combined bar plots
    for c in range(len(title)):

        # Setting the plot size for each plot
        fig, ax = plt.subplots(figsize =(10, 7))

        # Drawing the bars of its correspondng data
        rects1 = ax.bar(x - width/2, data[k], width, label=plot_labels1[c])
        rects2 = ax.bar(x + width/2, data[k+1], width, label=plot_labels2[c])

        k=k+2

        # Adding some text for labels, title and custom x-axis tick labels, etc.
        ax.set_ylabel(ylabels[c],fontweight ='bold')
        ax.set_xlabel('File Names',fontweight ='bold')
        ax.set_title(title[c])
        ax.set_xticks(x)
        ax.set_xticklabels(labels, rotation=90)
        ax.legend()
        plt.savefig(filepath  + "/" + title[c] + ".pdf")
        plt.ioff()


        def autolabel(rects):
            """Attaching a text label above each bar in *rects*, displaying its height."""
            for rect in rects:
                height = rect.get_height()
                ax.annotate('{}'.format(height),
                            xy=(rect.get_x() + rect.get_width() / 2, height),
                            xytext=(0, 3),  # 3 points vertical offset
                            textcoords="offset points",
                            ha='center', va='bottom')


        autolabel(rects1)
        autolabel(rects2)

        fig.tight_layout()

        plt.show()

if __name__=='__main__':
    happy_plots()
