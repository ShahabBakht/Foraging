function posteriorMap = predictFixation (Targets,SM,myLatency)

numIterations = length(myLatency);
posteriorMap = zeros(size(SM));
LL = zeros(size(SM,1),size(SM,2),numIterations);
 LLsmall = imresize(LL,.5);
Gaussian2D = @(xx,yy,mx,my,stdx,stdy)exp(-((xx-mx).^2./(2*stdx.^2)+(yy-my).^2./(2*stdy.^2)));
[xx,yy] = meshgrid(1:size(LLsmall,2),1:size(LLsmall,1));
stdx = 30;stdy = 30;
MEMory = 10;
for iter = 1:numIterations
    fprintf(['iteration # ',num2str(iter), '\n']);
   
    if myLatency(iter) < 20 * 1000 % has the subject observed this sample? if not, posterior shouldn't be updated
        thisObservation = Targets(iter,:) + 60 * rand - 30; % observation noise: because of window
        tic;
        for x = 1:size(LLsmall,2)
            for y = 1:size(LLsmall,1)
                fprintf(['likelihood x = ',num2str(x), ' y = ',num2str(y), '\n']);
%                 qmean = [x,y];
                testMap = Gaussian2D(xx,yy,x,y,stdx,stdy);
                LLsmall(y,x,iter) = testMap(round(thisObservation(2)/2),round(thisObservation(1)/2));
%                 figure(1);imagesc(LL);pause(0.1)
            end
        end
        toc;
        LL = imresize(LLsmall,size(SM));
        posteriorMap(:,:,iter) = (sum(LL(:,:,max(1,iter-MEMory):iter),3) .* double(SM)) ./ sum(sum(sum(LL(:,:,max(1,iter-MEMory):iter),3) .*  double(SM)));
        modelEvidence(iter) = sum(sum(sum(LL(:,:,max(1,iter-MEMory):iter),3) .*  double(SM)));
        figure(1);subplot(2,2,3);imagesc(squeeze(posteriorMap(:,:,iter)));title('Posterior');axis image;
        subplot(2,2,2);imagesc(sum(LL(:,:,max(1,iter-MEMory):iter),3));title('Likelihood');axis image
        subplot(2,2,1);imagesc(SM);title('Prior');axis image;
        subplot(2,2,4);plot(1:iter,modelEvidence,'o-k');title('model evidence');pause(0.1)
    else
        if iter > 1
            posteriorMap(:,:,iter) = posteriorMap(:,:,iter - 1);
        else
            posteriorMap(:,:,iter) = SM;
        end
    end
end



end