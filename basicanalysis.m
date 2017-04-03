TestName = '17032301';
DataFolder = 'D:\Data\Psychophysics\Foraging\';
load([DataFolder,TestName]);
% trialOrder = FVresult1.trialsOrder;
% allTrials = FVresult1.allTrials;
% fixX = FVresult1.FixationX;
% fixY = FVresult1.FixationY;
% 
% trialOrder2 = FVresult2.trialsOrder;
% allTrials2 = FVresult2.allTrials;
% fixX2 = FVresult2.FixationX;
% fixY2 = FVresult2.FixationY;

winHeight = FORAGEresult.winHeight;
winWidth = FORAGEresult.winWidth;
wRect = FORAGEresult.wRect;
ScreenCov_h = FORAGEresult.StimulusObject.ScreenCov_h;
ScreenCov_v = FORAGEresult.StimulusObject.ScreenCov_v;
maxJitter = FORAGEresult.StimulusObject.maxJitter;
PPD_X = FORAGEresult.StimulusObject.PPD_X;

scaleBGh = (wRect(3) * ScreenCov_h/2 - maxJitter*PPD_X)/(wRect(3) * ScreenCov_h/2);
    scaleBGv = (wRect(4) * ScreenCov_v/2 - maxJitter*PPD_X)/(wRect(4) * ScreenCov_v/2);

    % part of the screen that have been used to show images
windowSubPart_0 = [...
        winWidth/2 + 0 - (wRect(3) * ScreenCov_h/2) * scaleBGh,...
        winHeight/2 + 0 - (wRect(4) * ScreenCov_v/2) * scaleBGv, ...
        winWidth/2 + 0 + (wRect(3) * ScreenCov_h/2) * scaleBGh, ...
        winHeight/2 + 0 + (wRect(4) * ScreenCov_v/2) * scaleBGv ...
        ];
    
    
windowSubPart_1 = [...
winWidth/2 + 0 - (wRect(3) * ScreenCov_h/2) * 1,...
winHeight/2 + 0 - (wRect(4) * ScreenCov_v/2) * 1, ...
winWidth/2 + 0 + (wRect(3) * ScreenCov_h/2) * 1, ...
winHeight/2 + 0 + (wRect(4) * ScreenCov_v/2) * 1 ...
];

counter = zeros(3,2);
counter2 = zeros(3,2);



    

% for i = 1:40
%     imcount = allTrials(1,trialOrder(i));
%     typecount = allTrials(2,trialOrder(i));
%     counter(imcount,typecount) = counter(imcount,typecount) + 1;
%     FIXx{allTrials(1,trialOrder(i)),allTrials(2,trialOrder(i)),counter(imcount,typecount)} = fixX{i};
%     FIXy{allTrials(1,trialOrder(i)),allTrials(2,trialOrder(i)),counter(imcount,typecount)} = fixY{i};
%     
%     imcount2 = allTrials2(1,trialOrder2(i));
%     typecount2 = allTrials2(2,trialOrder2(i));
%     counter2(imcount2,typecount2) = counter2(imcount2,typecount2) + 1;
%     FIXx2{allTrials2(1,trialOrder2(i)),allTrials2(2,trialOrder2(i)),counter2(imcount2,typecount2)} = fixX2{i};
%     FIXy2{allTrials2(1,trialOrder2(i)),allTrials2(2,trialOrder2(i)),counter2(imcount2,typecount2)} = fixY2{i};
%     
% end
% 
% i = 0;
% for typecount = 1:2
%     for imcount = 1:2
%         if typecount == 1 && imcount == 1
%             imname = '34.png';
%         elseif typecount == 1 && imcount == 2
%             imname = '2.png';
%         elseif typecount == 2 && imcount == 1
%             imname = '38.png';
%         else
%             imname = '37.png';
%         end
%         thisIMG = (imread(['D:\Data\Psychophysics\Foraging\BGImages\17032301\',imname]));
%         thisIMG = imresize(thisIMG,[windowSubPart_1(4)-windowSubPart_1(2),windowSubPart_1(3)-windowSubPart_1(1)]);
%         i = i + 1;
%         figure(11);subplot(2,2,i);imshow(thisIMG);hold on
%         figure(12);subplot(2,2,i);imshow(thisIMG);hold on
%         for trcount = 1:10
%         
%         figure(11);subplot(2,2,i),plot(FIXx{imcount,typecount,trcount} - windowSubPart_1(1),FIXy{imcount,typecount,trcount}- windowSubPart_1(2),'.g','MarkerSize',20);hold on;set(gca,'YDir','Reverse');%xlim([200,1000]);ylim([300,800]); 
%         figure(12);subplot(2,2,i),plot(FIXx2{imcount,typecount,trcount} - windowSubPart_1(1),FIXy2{imcount,typecount,trcount}- windowSubPart_1(2),'.r','MarkerSize',20);hold on;set(gca,'YDir','Reverse');%xlim([200,1000]);ylim([300,800]); 
%         end
%     end
% end

FixationX = Output.fixXsorted;
FixationY = Output.fixYsorted;
X = Output.Xsorted;
Y = Output.Ysorted;
Jitters = Output.Jitters;
Latency = Output.Latency/1000;
Latencysmooth = Output.Latencysmooth/1000;
clickTargetPosition = CLICKresult.targetPosition;
TargetLocation = Output.targetLocationsorted;

figure;subplot(2,2,1);plot(Latency(1,:),'o'); ...
subplot(2,2,2); plot(Latency(2,:),'o'); ...
subplot(2,2,3); plot(Latency(3,:),'o'); ...
subplot(2,2,4); plot(Latency(4,:),'o');

figure;subplot(2,2,1);plot(Latencysmooth(1,1:4),'o-'); ...
subplot(2,2,2); plot(Latencysmooth(2,1:4),'o-'); ...
subplot(2,2,3); plot(Latencysmooth(3,1:4),'o-'); ...
subplot(2,2,4); plot(Latencysmooth(4,1:4),'o-');



k = 0;
figure(20)
for imcount = 1:4
for trcount = 1:10:40
    k = k +1;
    thisFixX = [];
    thisFixY = [];
    thisX = [];
    thisY = [];
    thisTargetX = [];
    thisTargetY = [];
    for i = 0:9
        tempFixX = FixationX{imcount,trcount + i} - Jitters(imcount,trcount + i,1) - windowSubPart_0(1);
        tempFixY = FixationY{imcount,trcount + i} - Jitters(imcount,trcount + i,2) - windowSubPart_0(2);
        thisFixX = [thisFixX,tempFixX];
        thisFixY = [thisFixY,tempFixY];
        tempTargetX = TargetLocation(imcount,trcount + i,1) - Jitters(imcount,trcount + i,1) - windowSubPart_0(1);
        tempTargetY = TargetLocation(imcount,trcount + i,2) - Jitters(imcount,trcount + i,2) - windowSubPart_0(2);
        thisTargetX = [thisTargetX,tempTargetX];
        thisTargetY = [thisTargetY,tempTargetY];
    end
    VAR(imcount,trcount) = mean(sqrt(var(thisFixX) + var(thisFixY)));
    thisIMG = imread(['D:\Data\Psychophysics\Foraging\BGImages\17032301\',FORAGEresult.StimulusObject.BGImages2Use(imcount,:)]);
    thisSM = imread(['D:\Data\Psychophysics\Foraging\BGImages\17032301\Deep Gaze II\1\',FORAGEresult.StimulusObject.BGImages2Use(imcount,:)]);
    thisIMG = imresize(thisIMG,[windowSubPart_0(4)-windowSubPart_0(2),windowSubPart_0(3)-windowSubPart_0(1)]);
    thisSM = imresize(thisSM,[windowSubPart_0(4)-windowSubPart_0(2),windowSubPart_0(3)-windowSubPart_0(1)]);
   figure(23); subplot(4,4,k);imshow(thisIMG)
    hold on
    figure(23);subplot(4,4,k);plot(thisFixX,thisFixY,'.g','MarkerSize',15);set(gca,'YDir','Reverse');xlim([0,windowSubPart_0(3) - windowSubPart_0(1)]);ylim([0,windowSubPart_0(4) - windowSubPart_0(2)]);
    hold on
    figure(23);subplot(4,4,k);plot(thisTargetX,thisTargetY,'*r');set(gca,'YDir','Reverse');xlim([0,windowSubPart_0(3) - windowSubPart_0(1)]);ylim([0,windowSubPart_0(4) - windowSubPart_0(2)]);
    figure(24); subplot(4,4,k);imagesc(thisSM);axis image; colormap(gray)
    hold on
    figure(24);subplot(4,4,k);plot(thisFixX,thisFixY,'.g','MarkerSize',15);set(gca,'YDir','Reverse');xlim([0,windowSubPart_0(3) - windowSubPart_0(1)]);ylim([0,windowSubPart_0(4) - windowSubPart_0(2)]);
    hold on
    figure(24);subplot(4,4,k);plot(thisTargetX,thisTargetY,'.r');set(gca,'YDir','Reverse');xlim([0,windowSubPart_0(3) - windowSubPart_0(1)]);ylim([0,windowSubPart_0(4) - windowSubPart_0(2)]);

    %     tempclickTargetPositionX = clickTargetPosition(1,imcount) - windowSubPart_0(1);
%     tempclickTargetPositionY = clickTargetPosition(2,imcount) - windowSubPart_0(2);
%     subplot(4,5,k);plot(tempclickTargetPositionX,tempclickTargetPositionY,'og')
    
end
end
    
% figure;
% 
% for imcount = 1:4
%     thisIMG = imread(['D:\Data\Psychophysics\Foraging\BGImages\17032301\',FORAGEresult.StimulusObject.BGImages2Use(imcount,:)]);
%     subplot(2,2,imcount);imagesc(imresize((thisIMG),[size(thisIMG,1)*ScreenCov_v,size(thisIMG,2)*ScreenCov_h]));axis image
% end

%% prepare for predictFixation

whichIMG = 4;

for imcount = 1:4
for trcount = 1:40
thisFixationX{imcount,trcount} = FixationX{imcount,trcount} - Jitters(imcount,trcount ,1) - windowSubPart_0(1);
thisFixationY{imcount,trcount} = FixationY{imcount,trcount} - Jitters(imcount,trcount ,2) - windowSubPart_0(2);
end
end

for imcount = 1:4
for trcount = 1:40
tempTargetX(imcount,trcount,1) = TargetLocation(imcount,trcount ,1) - Jitters(imcount,trcount ,1) - windowSubPart_0(1);
tempTargetX(imcount,trcount,2) = TargetLocation(imcount,trcount ,2) - Jitters(imcount,trcount ,2) - windowSubPart_0(2);
end
end

thisTarget = squeeze(tempTargetX(whichIMG,:,:));
thisFixX = cell(1,40);thisFixY = cell(1,40);
for iter = 1:40
thisFixX{1,iter} = thisFixationX{whichIMG,iter};
end
for iter = 1:40
thisFixY{1,iter} = thisFixationY{whichIMG,iter};
end

myLatency = Latency(whichIMG,:);

SaliencyMap = imread('D:\Data\Psychophysics\Foraging\BGImages\17032301\Deep Gaze II\1\37.png');
SaliencyMap_resize = imresize((SaliencyMap),[windowSubPart_0(4)-windowSubPart_0(2),windowSubPart_0(3)-windowSubPart_0(1)]);
SM = SaliencyMap_resize;

[posteriorMap,fixProb,fixProbUniform] = predictFixation (thisTarget,SM,myLatency,thisFixX,thisFixY);

%% patch analysis

WIN = 100;
figure;
for imcount = 1:4
        thisSM = imread(['D:\Data\Psychophysics\Foraging\BGImages\17031301\Deep Gaze II\1\',FORAGEresult.StimulusObject.BGImages2Use(imcount,:)]);
        thisSM = imresize(thisSM,[windowSubPart_0(4)-windowSubPart_0(2),windowSubPart_0(3)-windowSubPart_0(1)]);
        tempTargetX = mean(TargetLocation(imcount,:,1) - Jitters(imcount,:,1),2) - windowSubPart_0(1);
        tempTargetY = mean(TargetLocation(imcount,:,2) - Jitters(imcount,:,2),2) - windowSubPart_0(2);
        [sizeV,sizeH] = size(thisSM);
        startV = max(1,round(tempTargetY) - WIN/2);
        startH = max(1,round(tempTargetX) - WIN/2);
        endV = min(startV + WIN/2,sizeV);
        endH = min(startH + WIN/2,sizeH);
        
        Patch(imcount,:,:) = thisSM(startV:endV,startH:endH);
        subplot(2,2,imcount);imagesc(squeeze(Patch(imcount,:,:)));axis image;colormap(gray);caxis([0,200])
        
end