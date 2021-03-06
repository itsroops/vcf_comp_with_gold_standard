# Importing necessary packages
import sys
import pandas as pd
import csv
import os
import glob
import matplotlib
import matplotlib.pyplot as plt
import numpy as np
import xlsxwriter
from string import ascii_uppercase


def autolabel(rects,ax):
    """
    Attaching a text label above each bar in *rects*, displaying its height.
            
    Parameters: 
    rects: Individual bar plot object
    ax: The object for each subplot.
            
    Returns:
    Does not return anything
            
    """
    for rect in rects:
        height = rect.get_height()
        ax.annotate('{}'.format(height),
                    xy=(rect.get_x() + rect.get_width() / 2, height),
                    xytext=(0, 3),  # 3 points vertical offset
                    textcoords="offset points",
                    ha='center', va='bottom')


def happy_plots():
    """
    Plots the combined barplots of the performance metrices for all the VCFs for both SNPs and Indels
            
    Parameters: 
    None of the parameters are required
    
    Returns:
    Does not return anything
            
    """
    
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


     # Finding the lengest filename
    longest_string = max(labels, key=len)
    
    # Finding the length of the file with the longest filename
    maxl = len(longest_string)
    
    # Making the excel file containing the metrices
    
    # Initializing the excel workbook
    workbook = xlsxwriter.Workbook(filepath + '/Analysis.xlsx')
    worksheet = workbook.add_worksheet('Metrics Scores.xlsx')

    # Setting the cell width
    worksheet.set_column('A:A', maxl)
    worksheet.set_column('B:M', 10)
    
    # Create a format to use in the merged range.
    merge_format = workbook.add_format({
    'bold': 1,
    'border': 1,
    'align': 'center',
    'valign': 'vcenter',
    'fg_color': '#D7E4BC'})
    
    # Displaying the headers
    worksheet.merge_range('A1:A3', 'File Names', merge_format)
    worksheet.merge_range('B1:E1', 'Precision', merge_format)
    worksheet.merge_range('F1:I1', 'Recall', merge_format)
    worksheet.merge_range('J1:M1', 'F1 Score', merge_format)
    worksheet.merge_range('B2:C2', 'INDEL', merge_format)
    worksheet.merge_range('D2:E2', 'SNP', merge_format)
    worksheet.merge_range('F2:G2', 'INDEL', merge_format)
    worksheet.merge_range('H2:I2', 'SNP', merge_format)
    worksheet.merge_range('J2:K2', 'INDEL', merge_format)
    worksheet.merge_range('L2:M2', 'SNP', merge_format)
    
    s=str(3)
    x=1
    for c in ascii_uppercase:
        if c=='A':
            continue
        elif c>'M':
            break
        else:
            k=c+s
            x=x+1
            if x%2==0:
                worksheet.write(k,"ALL", merge_format)
            else:
                worksheet.write(k,"PASS", merge_format)
    
    # Defining the cell format for the values
    cell_fmt = workbook.add_format({'align': 'center','valign': 'vcenter', 'border': 1, 'num_format': '0.00'})
    filename_fmt = workbook.add_format({'align': 'left', 'valign': 'vcenter', 'border': 1})
    
    row=3
    for i in range(len(labels)):
        worksheet.write(row,0,labels[i], filename_fmt)
        
        arr = np.array(metric_precision_i_all)
        where_are_NaNs = np.isnan(arr)
        arr[where_are_NaNs] = 0.0
        worksheet.write(row,1,arr[i], cell_fmt )
        
        arr = np.array(metric_precision_i_pass)
        where_are_NaNs = np.isnan(arr)
        arr[where_are_NaNs] = 0.0
        worksheet.write(row,2,arr[i], cell_fmt )
        
        arr = np.array(metric_precision_s_all)
        where_are_NaNs = np.isnan(arr)
        arr[where_are_NaNs] = 0
        worksheet.write(row,3,arr[i], cell_fmt )
        
        arr = np.array(metric_precision_s_pass)
        where_are_NaNs = np.isnan(arr)
        arr[where_are_NaNs] = 0.0
        worksheet.write(row,4,arr[i], cell_fmt )
        
        arr = np.array(metric_recall_i_all)
        where_are_NaNs = np.isnan(arr)
        arr[where_are_NaNs] = 0.0
        worksheet.write(row,5,arr[i], cell_fmt )    
            
        arr = np.array(metric_recall_i_pass)
        where_are_NaNs = np.isnan(arr)
        arr[where_are_NaNs] = 0.0
        worksheet.write(row,6,arr[i], cell_fmt )
            
        arr = np.array(metric_recall_s_all)
        where_are_NaNs = np.isnan(arr)
        arr[where_are_NaNs] = 0.0
        worksheet.write(row,7,arr[i], cell_fmt )    
            
        arr = np.array(metric_recall_s_pass)
        where_are_NaNs = np.isnan(arr)
        arr[where_are_NaNs] = 0.0
        worksheet.write(row,8,arr[i], cell_fmt )
             
          
        arr = np.array(metric_f1_i_all)
        where_are_NaNs = np.isnan(arr)
        arr[where_are_NaNs] = 0.0
        worksheet.write(row,9,arr[i], cell_fmt)
        
        arr = np.array(metric_f1_i_pass)
        where_are_NaNs = np.isnan(arr)
        arr[where_are_NaNs] = 0.0
        worksheet.write(row,10,arr[i], cell_fmt)
        
       
        arr = np.array(metric_f1_s_all)
        where_are_NaNs = np.isnan(arr)
        arr[where_are_NaNs] = 0.0
        worksheet.write(row,11,arr[i], cell_fmt)
        
     
        arr = np.array(metric_f1_s_pass)
        where_are_NaNs = np.isnan(arr)
        arr[where_are_NaNs] = 0.0
        worksheet.write(row,12,arr[i], cell_fmt) 
        row = row + 1
    
    # Closing the workbook
    workbook.close()
        
    # Plotting for combined barplots with for SNPs and Indels for each individual performance metrices in different plots
        
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
    width = 0.2  

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
        ax.set_ylim([0,1])
        ax.set_xticklabels(labels, rotation=90)
        ax.legend(bbox_to_anchor=(1.05,1), loc='upper left')
        plt.yticks([0.00,0.05,0.10,0.15,0.20,0.25,0.30,0.35,0.40,0.45,0.50,0.55,0.60,0.65,0.70,0.75,0.80,0.85,0.90,0.95,1.00])
        plt.savefig(filepath  + "/" + title[c] + ".pdf", format="pdf", bbox_inches = 'tight')
        plt.ioff()

        autolabel(rects1,ax)
        autolabel(rects2,ax)

        fig.tight_layout()

        plt.show()
        
        
    # Plotting for combined barplots with all performance metrices for SNPs and Indels

    # Setting the y-axis labels for the plots
    ylabels=['Metrics Scores','Metrics Scores','Metrics Scores','Metrics Scores']

    # Setting the title of the combined bar plots
    title=['Bar_Chart_for_ALL_for_Type=Indel','Bar_Chart_for_ALL_for_Type=SNP',
           'Bar_Chart_for_PASS_for_Type=Indel','Bar_Chart_for_PASS_for_Type=SNP']

    
    data = [metric_precision_i_all, metric_recall_i_all, metric_f1_i_all, metric_precision_s_all, 
            metric_recall_s_all, metric_f1_s_all, metric_precision_i_pass, metric_recall_i_pass,
            metric_f1_i_pass, metric_precision_s_pass, metric_recall_s_pass, metric_f1_s_pass]
    
    # Setting the legends for the combined bar plots
    plot_labels1=['Precision','Precision','Precision','Precision']
    plot_labels2=['Recall','Recall','Recall','Recall']
    plot_labels3=['F1 Score','F1 Score','F1 Score','F1 Score']

    # Setting the label locations
    x = np.arange(len(labels))  

    # Setting the width of the bars
    width = 0.2  

    k=0

     # Plotting the combined bar plots
    for c in range(len(title)):

        # Setting the plot size for each plot
        fig, ax = plt.subplots(figsize =(10, 7))

        # Drawing the bars of its correspondng data
        rects1 = ax.bar(x - width, data[k], width, label=plot_labels1[c])
        rects2 = ax.bar(x, data[k+1], width, label=plot_labels2[c])
        rects3 = ax.bar(x + width, data[k+2], width, label=plot_labels3[c])

        k=k+3

        # Adding some text for labels, title and custom x-axis tick labels, etc.
        ax.set_ylabel(ylabels[c],fontweight ='bold')
        ax.set_xlabel('File Names',fontweight ='bold')
        ax.set_title(title[c])
        ax.set_xticks(x)
        ax.set_ylim([0,1])
        ax.set_xticklabels(labels, rotation=90)
        ax.legend(bbox_to_anchor=(1.05,1), loc='upper left')
        plt.yticks([0.00,0.05,0.10,0.15,0.20,0.25,0.30,0.35,0.40,0.45,0.50,0.55,0.60,0.65,0.70,0.75,0.80,0.85,0.90,0.95,1.00])
        plt.savefig(filepath  + "/" + title[c] + ".pdf", format="pdf", bbox_inches = 'tight')
        plt.ioff()
        
        autolabel(rects1,ax)
        autolabel(rects2,ax)
        autolabel(rects3,ax)

        fig.tight_layout()

        plt.show()

if __name__=='__main__':
    happy_plots()
