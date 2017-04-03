function [posteriorMap,fixProb,fixProbUniform] = predictFixation (Targets,SM,myLatency,FixX,FixY)

SM = double(SM); SM = SM./sum(SM(:));
SMuniform = ones(size(SM)); SMuniform = SMuniform./sum(SMuniform(:));

Weight = 1;
numIterations = length(myLatency);
posteriorMap = zeros(size(SM));
posteriorMapUniform = zeros(size(SM));
LL = zeros(size(SM,1),size(SM,2),numIterations);
 LLsmall = imresize(LL,.5);
Gaussian2D = @(xx,yy,mx,my,stdx,stdy)exp(-((xx-mx).^2./(2*stdx.^2)+(yy-my).^2./(2*stdy.^2)));
[xx,yy] = meshgrid(1:size(LLsmall,2),1:size(LLsmall,1));
stdx = 100;stdy = 100;
MEMory = 10;
for iter = 1:40%numIterations
    fprintf(['iteration # ',num2str(iter), '\n']);
   
    if myLatency(iter) < 20 * 1000 % has the subject observed this sample? if not, posterior shouldn't be updated
        while 1
            whishsample = iter;% randi(numIterations);%
%         thisObservation = Targets(whishsample,:);% + 100 * rand - 30; % observation noise: because of window
        thisObservation(1) = FixX{iter}(end);
        thisObservation(2) = FixY{iter}(end);
        if ~any(thisObservation<0)
            break
        end
        end
        tic;
        for x = 1:size(LLsmall,2)
            for y = 1:size(LLsmall,1)
                fprintf(['likelihood x = ',num2str(x), ' y = ',num2str(y), '\n']);
%                 qmean = [x,y];
                testMap = Gaussian2D(xx,yy,x,y,stdx,stdy);
                if ceil(thisObservation(2)/2) <= size(testMap,1) && ceil(thisObservation(1)/2) <= size(testMap,2)
                    LLsmall(y,x,iter) = testMap(ceil(thisObservation(2)/2),ceil(thisObservation(1)/2));
                else
                    if iter > 1
                        LLsmall(y,x,iter) = LLsmall(y,x,iter-1);
                    else
                        LLsmall(y,x,iter) = 1;
                    end
                end
%                 figure(1);imagesc(LL);pause(0.1)
            end
        end
        toc;
        LL = imresize(LLsmall,size(SM));
        
        posteriorMap(:,:,iter) = ( prod(LL(:,:,max(1,iter-MEMory):iter),3) .* (SM)) ./ sum(sum(prod(LL(:,:,max(1,iter-MEMory):iter),3) .*  (SM)));
        modelEvidence(iter) = sum(sum(prod(LL(:,:,max(1,iter-MEMory):iter),3) .* (SM)));
        
        posteriorMapUniform(:,:,iter) = ( prod(LL(:,:,max(1,iter-MEMory):iter),3) .* (SMuniform)) ./ sum(sum(prod(LL(:,:,max(1,iter-MEMory):iter),3) .*  (SMuniform)));
         modelEvidenceUniform(iter) = sum(sum(prod(LL(:,:,max(1,iter-MEMory):iter),3) .* (SMuniform)));
        
        figure(10);subplot(3,2,3);imagesc(squeeze(posteriorMap(:,:,iter)));title('Posterior');axis image;
        subplot(3,2,2);imagesc(prod(LL(:,:,max(1,iter-MEMory):iter),3));title('Likelihood');axis image
        subplot(3,2,1);imagesc(SM);title('Prior');axis image;
        subplot(3,2,6);plot(1:iter,modelEvidence./modelEvidenceUniform,'o-k');title('model evidence');
        subplot(3,2,4);plot(1:iter,modelEvidence,'o-k');title('model evidence');pause(0.1);
    else
        if iter > 1
            posteriorMap(:,:,iter) = posteriorMap(:,:,iter - 1);
            posteriorMapUniform(:,:,iter) = posteriorMapUniform(:,:,iter - 1);
        else
            posteriorMap(:,:,iter) = SM;
            posteriorMapUniform(:,:,iter) = SM;
        end
    end
end

%% Sampling
figure(10);
for  iter = 2:40%numIterations
    
    thisfixX = FixX{iter};
    thisfixY = FixY{iter};
    idxX = thisfixX > 0 & thisfixX < size(posteriorMap,1) & thisfixY > 0 & thisfixY < size(posteriorMap,2);
    
    subplot(3,2,5);imagesc(posteriorMap(:,:,iter-1));axis image;hold on
%     if idxX(end) == 1
    plot(ceil(thisfixX(idxX)),ceil(thisfixY(idxX)),'+r');hold off;pause(0.1)
    fixMap = ((posteriorMap(ceil(thisfixX(idxX)),ceil(thisfixY(idxX)),iter-1)));
    fixMap(fixMap == 0) = 1;
    fixMap = prod(prod(fixMap));
    fixProb(iter) = prod(fixMap(:));
    
    fixMapUniform = ((posteriorMapUniform(ceil(thisfixX(idxX)),ceil(thisfixY(idxX)),iter-1)));
    fixMapUniform(fixMapUniform == 0) = 1;
    fixMapUniform = prod(prod(fixMapUniform));
    fixProbUniform(iter) = prod(fixMapUniform(:));
%     end
    
end
end