
% Calcula TPd, FPd, TNd e FNd (em relação ao DifMap) dos algoritmos que utilizados na validação
clear;

%load algorithmConfusionmatrixTESTE.mat;

ResOutAlgPath = '/DADOS/Silvio/OflineData/ChangeDetectionData/ResultsSiteNoMap'; %recebendo do usuario a pasta onde estao os resultados
GTPath = '/DADOS/Silvio/OflineData/ChangeDetectionData/dataset2014Full/dataset';
MapPath = '/DADOS/Silvio/OflineData/ChangeDetectionData/DifficultyMap';

 algList = filesys('getFolders', ResOutAlgPath); %listando as pastas em resultados   
 qtde_algoritmos = length(algList); %quantidade de algoritmos
 categoryList = filesys('getFolders', GTPath); 
 qtde_category = length(categoryList);

 
 %for l=1:1%qtde_algoritmos
 for l=1:qtde_algoritmos
     fprintf('Algorithm %d \n',l);
     
     for i = 1:qtde_category % loop categories
     %for i = 3:3%qtde_category % loop categories
            categoryPath = [GTPath '/' categoryList{i}];
            videoList = filesys('getFolders', [GTPath '/' categoryList{i}]);
            qtde_videos = length(videoList);
            %fprintf('%s\n',categoryList{i});
            
            for j = 1:qtde_videos %loop videos           
            %for j = 1:1%qtde_videos %loop videos           
                
                confusionMatrix = [0 0 0 0]; % TP FP FN TN SE
                fileID = fopen([GTPath '/' categoryList{i} '/' videoList{j} '/temporalROI.txt']);
                C = textscan(fileID,'%d %d');
                InitFrame = C{1}; qtde_frames=C{2};
                
                GTVideoPath = [GTPath '/' categoryList{i} '/' videoList{j} '/groundtruth'];
                AlgPath = [ResOutAlgPath '/' algList{l} '/results/' categoryList{i} '/' videoList{j}];
                MapVideoPath = [MapPath '/' categoryList{i} '/' videoList{j}] ;
                fprintf('Alg %d, Cat %s, Vid %s\n',l, categoryList{i}, videoList{j});                    
                
                for k=InitFrame:qtde_frames % loop frames
                    
                    
                    GTname = sprintf('%s/gt%.6d.png',GTVideoPath,k);
                    IM_GT = imread(GTname);
                    G = double(IM_GT);
                    G = round(G/255,2);
                                        
                    AlgName = sprintf('%s/bin%.6d.png',AlgPath,k);
                    IM_SEG = logical(imread(AlgName(:,:,1)));
                    S = double(IM_SEG);
                                       
                    
                    %imBinary = double(IM_SEG(:,:,1));
                    %S = imbinarize(imBinary, 0.5);
                    %S = double(S);
                                       
                    
%                     for ii=size(IM_SEG,1)
%                         for jj=size(IM_SEG,2)
%                             if(S(ii,jj)== 0 || S(ii,jj)==1)
%                                 fprintf('Ok %f \n',S(ii,jj));
%                             else
%                                 fprintf('Problem %f \n',S(ii,jj));
%                                 pause();
%                             end
%                         end
%                     end                 
                    
                                        
                    MapName = sprintf('%s/dm%.6d.png',MapVideoPath,k);
                    IM_DIF = imread(MapName);
                    D = double(IM_DIF);
                    D = round(D/255,2);
                                       
                    confusionMatrix = confusionMatrix + compare(S, G, D);
                    
                    %confusionMatrix = processVideoFolder(idcategory, idvideo, videoPath, binaryPath);                
                end
                
                Confusion_TP_FP_FN_TN_DifMap(l).category(i).video(j).confusionmatrix = confusionMatrix;
                %algTest(l).category(i).video(j).confusionmatrix = confusionMatrix;
                %save algTest algTest;
                %save Confusion_TP_FP_FN_TN_DifMap Confusion_TP_FP_FN_TN_DifMap;
            end
     end
 end
        

 
 function confusionMatrix = compare(Sp,Gp, Dp)
    % Compares a binary frames with the groundtruth frame
    R = zeros(size(Gp));
    for i=1:size(Gp,1)
        for j=1:size(Gp,2)
            if(Gp(i,j)==0 || Gp(i,j)==1)
                R(i,j) = 1;
            end
        end
    end
    S = Sp; G = Gp; D = Dp;
    
    %sum
%      TPd = sum(sum(times(times(times(G,S),R),D)));
%      TNd = sum(sum(times(times(times(1-G,1-S),R),D)));
%      FPd = sum(sum(times(times(times(1-G, S),R),D)));
%      FNd = sum(sum(times(times(times(G, 1-S),R),D)));
  
     TPd = sum(sum(sum(G .* S .* R .* D)));
     TNd = sum(sum(sum((1-G) .* (1-S) .* R .* D)));
     FPd = sum(sum(sum((1-G) .* S .* R .* D)));
     FNd = sum(sum(sum(G .* (1-S) .* R.* D)));      
      
%      TPd = sum(sum(times(times(G,S),R)));
%      TNd = sum(sum(times(times(1-G,1-S),R)));
%      FPd = sum(sum(times(times(1-G, S),R)));
%      FNd = sum(sum(times(times(G, 1-S),R)));

    confusionMatrix = [TPd FPd FNd TNd];
    %confusionMatrix = [TPD FPD FND TND];
end
       
