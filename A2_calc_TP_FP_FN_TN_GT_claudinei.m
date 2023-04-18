
% Calcula TP, FP, TN e FN (em relação ao GT) dos algoritmos que utilizados na validação
clear;

ResOutAlgPath = 'F:\ChangeDetection\resultsSiteNoMap'; %recebendo do usuario a pasta onde estao os resultados
GTPath = 'F:\ChangeDetection\dataset2014\dataset';

 algList = filesys('getFolders', ResOutAlgPath); %listando as pastas em resultados   
 qtde_algoritmos = length(algList); %quantidade de algoritmos
 categoryList = filesys('getFolders', GTPath); 
 qtde_category = length(categoryList);

 %for l=1:1%qtde_algoritmos
 for l=1:qtde_algoritmos
     fprintf('Algorithm %d \n',l);
     
     for i = 1:qtde_category % loop categories
     %for i = 3:3%qtde_category % loop categories
            categoryPath = [GTPath '\' categoryList{i}];
            videoList = filesys('getFolders', [GTPath '\' categoryList{i}]);
            qtde_videos = length(videoList);
                        
            for j = 1:qtde_videos %loop videos           
            %for j = 1:1%qtde_videos %loop videos           
                
                confusionMatrix = [0 0 0 0]; % TP FP FN TN SE
                fileID = fopen([GTPath '\' categoryList{i} '\' videoList{j} '\temporalROI.txt']);
                C = textscan(fileID,'%d %d');
                InitFrame = C{1}; qtde_frames=C{2};
                
                GTVideoPath = [GTPath '\' categoryList{i} '\' videoList{j} '\groundtruth'];
                AlgPath = [ResOutAlgPath '\' algList{l} '\results\' categoryList{i} '\' videoList{j}];
                fprintf('Alg %d %s, Cat %s, Vid %s\n',l, algList{l}, categoryList{i}, videoList{j});                    
                
                for k=InitFrame:qtde_frames % loop frames
                                     
                    GTname = sprintf('%s\\gt%.6d.png',GTVideoPath,k);
                    IM_GT = imread(GTname);
                    G = double(IM_GT);
                    G = round(G/255,2);
                                        
                    AlgName = sprintf('%s\\bin%.6d.png',AlgPath,k);
                    IM_SEG = logical(imread(AlgName(:,:,1)));
                    S = double(IM_SEG);               
                    confusionMatrix = confusionMatrix + compare(S, G);
                                  
                end
                
                Confusion_TP_FP_FN_TN_GT(l).category(i).video(j).confusionmatrix = confusionMatrix;
                save Confusion_TP_FP_FN_TN_GT Confusion_TP_FP_FN_TN_GT;
            end
     end
 end
        

 
 function confusionMatrix = compare(Sp,Gp)
    % Compares a binary frames with the groundtruth frame
    R = zeros(size(Gp));
    for i=1:size(Gp,1)
        for j=1:size(Gp,2)
            if(Gp(i,j)==0 || Gp(i,j)==1)
                R(i,j) = 1;
            end
        end
    end
    S = Sp; G = Gp;
    

     TPd = sum(sum(sum(G .* S .* R)));
     TNd = sum(sum(sum((1-G) .* (1-S) .* R)));
     FPd = sum(sum(sum((1-G) .* S .* R)));
     FNd = sum(sum(sum(G .* (1-S) .* R)));      

     confusionMatrix = [TPd FPd FNd TNd];
    
end
       
