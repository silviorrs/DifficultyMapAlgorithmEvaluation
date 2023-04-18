% Dificulty Map V1

%function main

%'/DADOS/Silvio/OflineData/ChangeDetectionData/dataset2014Full/dataset\PTZ\continuousPan\groundtruth\gt000001.png'

    clear;
    ResPath = '/DADOS/Silvio/OflineData/ChangeDetectionData/resultsSite'; %recebendo do usuario a pasta onde estao os resultados
    datasetPath = '/DADOS/Silvio/OflineData/ChangeDetectionData/dataset2014Full/dataset'; % caminho para o dataset
    %MapPath = '/DADOS/Silvio/OflineData/ChangeDetectionData/DifficultyMap'; % diretorio onde será gravado o mapa de dificuldade
    MapPath = '/home/silvio/DifficultyMap/';
    
    algList = filesys('getFolders', ResPath); %listando as pastas em resultados   
    qtde_algoritmos = length(algList); %quantidade de pastas em resultados
    categoryList = filesys('getFolders', datasetPath);
    qtde_category = length(categoryList);
    
    tic
    
    for i = 1:qtde_category % loop categories
        fprintf('Cat %d',i);
        categoryPath = [datasetPath '/' categoryList{i}];
        videoList = filesys('getFolders', [datasetPath '/' categoryList{i}]);
        qtde_videos = length(videoList);

        for j = 1:qtde_videos % loop videos           
            VideoSourcePath = [datasetPath '/' categoryList{i} '/' videoList{j}];
            FirstFrame = sprintf('%s/groundtruth/gt%.6d.png',VideoSourcePath,1);
            frameGT = imread(FirstFrame);
            sizeFrame = size(frameGT);            
            %qtde_frames=size(dir([[VideoSourcePath '/input'] '/*.jpg']),1);
            
            fileID = fopen([VideoSourcePath '/temporalROI.txt']);
            C = textscan(fileID,'%d %d');
            InitFrame = C{1}; qtde_frames=C{2};
            
            for k=InitFrame:qtde_frames % loop frames
                frameGTName = sprintf('%s/groundtruth/gt%.6d.png',VideoSourcePath,k);
                frameGT = imread(frameGTName);
                                
                DifFrameTotal = uint8(zeros(sizeFrame));             
                %fprintf('Cat %d %s, Vid %d %s, Frame %d \n',i,categoryList{i},j,videoList{j},k);
                
                %qtde_algoritmos = 4;
                
                for l=1:qtde_algoritmos
                    %fprintf(' %d',l);
                    DifFrame = uint8(zeros(sizeFrame));
                    frameResultName = sprintf('%s/%s/results/%s/%s/bin%.6d.png',ResPath,algList{l},categoryList{i},videoList{j},k); 
                    
                    % convert uint8 {0,255} to logical {0,1} 
                    % (:,:,1) to get only first chanell
                    frameResult = logical(imread(frameResultName(:,:,1)));
                    frameResult = uint8(frameResult*255);
                                        
%                     if(l == 1 )%|| l== 2 || l==3)
%                         frameResult(1,1)=1;
%                     else
%                         frameResult(1,1)=0;
%                     end
                    %fprintf('Alg %s \n',algList{l});figure(1);imshow(frameResult);figure(2);imshow(frameGT);pause();

                    for m=1: size(frameResult,1) % loop pixels
                        for n=1: size(frameResult,2)
                            if(frameGT(m,n) == 0 && frameResult(m,n) == 255) % False Positive
                                DifFrame(m,n) =  DifFrame(m,n)+1;  
                            end
                            if(frameGT(m,n) == 255 && frameResult(m,n) == 0) % False Negative
                                DifFrame(m,n) =  DifFrame(m,n)+1;  
                            end
                        end
                    end % end loop pixels
                    DifFrameTotal = DifFrameTotal + DifFrame;
                    
                end %end loop algorithms
                
                intervals = uint8(floor(255/qtde_algoritmos));                        
                frame(k).DifMap=DifFrameTotal*intervals;              
                imageName = sprintf('%s/%s/%s/dm%.6d.png',MapPath,categoryList{i},videoList{j},k);
                
                % descomentar a linha de baixo para gravar arquivos
               
                % imwrite(frame(k).DifMap,imageName); 
                
                
               
           
            
            end % end loop frames
            
        end % end loop videos
        
        
    %category(i).video = video;
    end %end loop categories
    
    timeElapsed = toc;
    save timeElapsed timeElapsed;
           
%end 
