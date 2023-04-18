% Comparação do FMeasure utilizando o GT e Mapa de Dificuldade

clear;
load Confusion_TP_FP_FN_TN_DifMap.mat;
load Confusion_TP_FP_FN_TN_GT.mat;
load Copy_of_algorithmConfusionmatrix.mat;

ResOutAlgPath = '/DADOS/Silvio/OflineData/ChangeDetectionData/ResultsSiteNoMap';
CatPath = '/DADOS/Silvio/OflineData/ChangeDetectionData/dataset2014Full/dataset';
algList = filesys('getFolders', ResOutAlgPath);
catList = filesys('getFolders', CatPath);

%algList = [{'BSUV_Net_808'} {'BSUV_net_SemanticBGS_809'} {'BinWangApr2014_123'}...
%           {'CL_VID_533'} {'DeepBS_458'} ...
%           {'FgSegNet_v2_SupervisedMethod__531'} {'IUTIS_2_175'} ...
%           {'M4CDVersion2_0_411'} {'MultiscaleSpatio_TemporalBGModel_132'}...
%           {'SWCD_526'} {'cascade_E_M_200_0_6_344'}];
       
%algList = [{'AAPSA_149'} {'ArunVarghese_422'} {'BMOG_463'}];

%for i=1:numel(algorithmConfusionmatrix)
for i=1:numel(Confusion_TP_FP_FN_TN_DifMap)
    TP=0; FP=0; FN=0; TN=0;
    TPd=0; FPd=0; FNd=0; TNd=0;
    algorithmMetricsDifMap(i).name = algList{i};
    algorithmMetricsDifMap(i).ID = i;
    
    algorithmMetricsGT(i).name = algList{i};
    algorithmMetricsGT(i).ID = i;
    
    
    %for j=1:numel(algorithmConfusionmatrix(i).category)       
        %for k=1:numel(algorithmConfusionmatrix(i).category(j).video)
    for j=1:numel(Confusion_TP_FP_FN_TN_DifMap(i).category)       
        
        for k=1:numel(Confusion_TP_FP_FN_TN_DifMap(i).category(j).video)
            TPd = TPd + Confusion_TP_FP_FN_TN_DifMap(i).category(j).video(k).confusionmatrix(1) ;
            FPd = FPd + Confusion_TP_FP_FN_TN_DifMap(i).category(j).video(k).confusionmatrix(2) ;
            FNd = FNd + Confusion_TP_FP_FN_TN_DifMap(i).category(j).video(k).confusionmatrix(3) ;
            TNd = TNd + Confusion_TP_FP_FN_TN_DifMap(i).category(j).video(k).confusionmatrix(4) ;
        end
        
        recall_Catd = TPd / (TPd + FNd);
        specficity_Catd = TNd / (TNd + FPd);
        FPR_Catd = FPd / (FPd + TNd);
        FNR_Catd = FNd / (TPd + FNd);
        PBC_Catd = 100.0 * (FNd + FPd) / (TPd + FPd + FNd + TNd);
        precision_Catd = TPd / (TPd + FPd);        
        FMeasure_Catd = 2.0 * (recall_Catd * precision_Catd) / (recall_Catd + precision_Catd);
               
        algorithmMetricsDifMap(i).cat(j).name = catList{j};
        algorithmMetricsDifMap(i).cat(j).recall = recall_Catd;
        algorithmMetricsDifMap(i).cat(j).specficity = specficity_Catd;
        algorithmMetricsDifMap(i).cat(j).FPR = FPR_Catd;
        algorithmMetricsDifMap(i).cat(j).FNR = FNR_Catd;
        algorithmMetricsDifMap(i).cat(j).PBC = PBC_Catd;
        algorithmMetricsDifMap(i).cat(j).precision = precision_Catd;
        algorithmMetricsDifMap(i).cat(j).FMeasure = FMeasure_Catd;
        
        clear recall_Catd specficity_Catd FPR_Catd FNR_Catd precision_Catd FMeasure_Catd PBC_Catd;
        %%%%%%%
        
        for k=1:numel(Confusion_TP_FP_FN_TN_GT(i).category(j).video)
            TP = TP + Confusion_TP_FP_FN_TN_GT(i).category(j).video(k).confusionmatrix(1) ;
            FP = FP + Confusion_TP_FP_FN_TN_GT(i).category(j).video(k).confusionmatrix(2) ;
            FN = FN + Confusion_TP_FP_FN_TN_GT(i).category(j).video(k).confusionmatrix(3) ;
            TN = TN + Confusion_TP_FP_FN_TN_GT(i).category(j).video(k).confusionmatrix(4) ;
        end
        
        recall_Cat = TP / (TP + FN);
        specficity_Cat = TN / (TN + FP);
        FPR_Cat = FP / (FP + TN);
        FNR_Cat = FN / (TP + FN);
        PBC_Cat = 100.0 * (FN + FP) / (TP + FP + FN + TN);
        precision_Cat = TP / (TP + FP);        
        FMeasure_Cat = 2.0 * (recall_Cat * precision_Cat) / (recall_Cat + precision_Cat);
        
        algorithmMetricsGT(i).cat(j).name = catList{j};
        algorithmMetricsGT(i).cat(j).recall = recall_Cat;
        algorithmMetricsGT(i).cat(j).specficity = specficity_Cat;
        algorithmMetricsGT(i).cat(j).FPR = FPR_Cat;
        algorithmMetricsGT(i).cat(j).FNR = FNR_Cat;
        algorithmMetricsGT(i).cat(j).PBC = PBC_Cat;
        algorithmMetricsGT(i).cat(j).precision = precision_Cat;
        algorithmMetricsGT(i).cat(j).FMeasure = FMeasure_Cat;
        
        clear recall_Cat specficity_Cat FPR_Cat FNR_Cat precision_Cat FMeasure_Cat PBC_Cat;   
        
    end
    
    recalld = TPd / (TPd + FNd);
    specficityd = TNd / (TNd + FPd);
    FPRd = FPd / (FPd + TNd);
    FNRd = FNd / (TPd + FNd);
    PBCd = 100.0 * (FNd + FPd) / (TPd + FPd + FNd + TNd);
    precisiond = TPd / (TPd + FPd);        
    FMeasured = 2.0 * (recalld * precisiond) / (recalld + precisiond);
    
     
    algorithmMetricsDifMap(i).overal.recall = recalld;
    algorithmMetricsDifMap(i).overal.specficity = specficityd;
    algorithmMetricsDifMap(i).overal.FPR = FPRd;
    algorithmMetricsDifMap(i).overal.FNR = FNRd;
    algorithmMetricsDifMap(i).overal.PBC = PBCd;
    algorithmMetricsDifMap(i).overal.precision = precisiond;
    algorithmMetricsDifMap(i).overal.FMeasure = FMeasured;
    
    clear recalld specficityd TNd TPd FNd FPd FPRd FNRd PBCd precisiond FMeasured;
    
    recall = TP / (TP + FN);
    specficity = TN / (TN + FP);
    FPR = FP / (FP + TN);
    FNR = FN / (TP + FN);
    PBC = 100.0 * (FN + FP) / (TP + FP + FN + TN);
    precision = TP / (TP + FP);        
    FMeasure = 2.0 * (recall * precision) / (recall + precision);
    
    algorithmMetricsGT(i).overal.recall = recall;
    algorithmMetricsGT(i).overal.specficity = specficity;
    algorithmMetricsGT(i).overal.FPR = FPR;
    algorithmMetricsGT(i).overal.FNR = FNR;
    algorithmMetricsGT(i).overal.PBC = PBC;
    algorithmMetricsGT(i).overal.precision = precision;
    algorithmMetricsGT(i).overal.FMeasure = FMeasure;
    
    clear recall specficity TN TP FN FP FPR FNR PBC precision FMeasure;
end

comp = [];

for i=1:numel(algorithmMetricsDifMap)
    %fprintf('Alg %.2d - GT % f , Alg %.2d Map %f \n', algorithmMetricsGT(i).ID ,algorithmMetricsGT(i).overal.FMeasure, algorithmMetricsGT(i).ID,  algorithmMetricsDifMap(i).overal.FMeasure);
    comp = [comp; algorithmMetricsGT(i).ID ,algorithmMetricsGT(i).overal.FMeasure, algorithmMetricsGT(i).ID,  algorithmMetricsDifMap(i).overal.FMeasure ];
end

comp = sortrows(comp, -2);

fprintf('\nComparação do FMeasure utilizando o GT e Mapa de Dificuldade\n\n');
for i=1:size(comp,1)
     fprintf('Alg %.2d - GT %f , Alg %.2d Map %f \n', comp(i,1), comp(i,2), comp(i,3), comp(i,4));
 
end



clear CatPath catList algList ResOutAlgPath i j k;
save algorithmMetricsDifMap algorithmMetricsDifMap 
save algorithmMetricsGT algorithmMetricsGT 