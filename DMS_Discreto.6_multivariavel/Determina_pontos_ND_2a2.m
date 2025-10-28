%%
%
% ler dms_paretofront.txt
fcache = fopen('dms_paretofront.txt','r');
aux    = str2num(fgetl(fcache));
n      = aux(1);
m      = aux(2);
k      = aux(3);
aux    = str2num(fgetl(fcache));
for i = 1:n
    aux = str2num(fgetl(fcache));
    for j = 1:m
        CacheP(i,j) = aux(j);
    end
end
aux = str2num(fgetl(fcache));
for i = 1:k
    aux = str2num(fgetl(fcache));
    for j = 1:m
        pf(i,j) = aux(j);
    end
end
aux = str2num(fgetl(fcache));
aux = str2num(fgetl(fcache));
for j = 1:m
    CachenormP(j) = aux(j);
end
fclose(fcache);

format short;

[mpf,npf]=size(pf);
for ii=1:npf
    pf(mpf+1,ii)=ii;
end

% figure(length(pf)+100)
% plot3(pf(1,:),pf(2,:),pf(3,:),'g.');
% hold on;
%     xlabel('f1');
%     ylabel('f2');
%     zlabel('f3');
%     title('Pareto Front');
%     %legend ('DMS results');
%     ylim('auto');
%  namefile = strcat('vv',int2str(length(pf)+100))
%  saveas(figure(length(pf)+100), namefile,'fig')
%  saveas(figure(length(pf)+100), namefile,'jpg')
%  saveas(figure(length(pf)+100), namefile,'pdf')
%
% figure(length(pf)+101)
% plot3(pf(1,:),pf(2,:),pf(3,:),'g.');
% hold on;
%     xlabel('f1');
%     ylabel('f2');
%     zlabel('f3');
%     title('Pareto Front');
%     %legend ('DMS results');
%     ylim('auto');
%     view([0 90])
%  namefile = strcat('vv',int2str(length(pf)+101))
%  saveas(figure(length(pf)+101), namefile,'fig')
%  saveas(figure(length(pf)+101), namefile,'jpg')
%  saveas(figure(length(pf)+101), namefile,'pdf')
%
% figure(length(pf)+102)
% plot3(pf(1,:),pf(2,:),pf(3,:),'g.');
% hold on;
%     xlabel('f1');
%     ylabel('f2');
%     zlabel('f3');
%     title('Pareto Front ');
%     %legend ('DMS results');
%     ylim('auto');
%     view([0 0])
%  namefile = strcat('vv',int2str(length(pf)+102))
%  saveas(figure(length(pf)+102), namefile,'fig')
%  saveas(figure(length(pf)+102), namefile,'jpg')
%  saveas(figure(length(pf)+102), namefile,'pdf')
%
%
% figure(length(pf)+103)
% plot3(pf(1,:),pf(2,:),pf(3,:),'g.');
% hold on;
%     xlabel('f1');
%     ylabel('f2');
%     zlabel('f3');
%     title('Pareto Front ');
%     %legend ('DMS results');
%     ylim('auto');
%     view([90 0])
%  namefile = strcat('vv',int2str(length(pf)+103))
%  saveas(figure(length(pf)+103), namefile,'fig')
%  saveas(figure(length(pf)+103), namefile,'jpg')
%  saveas(figure(length(pf)+103), namefile,'pdf')
%
%% objectivo1

for ja=1:(k-1)
    %% objectivo2
    for jb=(ja+1):k
        Fobj=[ pf(ja,:)
            pf(jb,:)];
        Flist= [Fobj(:,1)];
        for i=2:npf
            Ftemp =  [Fobj(:,i)];
            [pdom,index_ndom] = PD(Ftemp,Flist);
            if (pdom == 0)
                %Plist = [Plist(:,index_ndom),x_ini];
                Flist = [Flist(:,index_ndom),Ftemp];
            end
        end
        
        for ia=1:npf
            [a,bb]=size(Flist);
            for ib=1:bb
                if(Flist(1,ib)==pf(ja,ia) & Flist(2,ib)==pf(jb,ia))
                    Flist(3,ib)=pf(mpf+1,ia);
                end
            end
        end
        nnn=ja*100+jb;
        figure(nnn);
        for ik=1:bb
            if Flist(1,ik)<0
                Flist(1,ik)=-Flist(1,ik);
            end
            if Flist(2,ik)<0
                Flist(2,ik)=-Flist(2,ik);
            end
            plot(Flist(1,ik),Flist(2,ik),'');hold on;
            text(Flist(1,ik),Flist(2,ik),num2str(Flist(3,ik)));
            hold on;
        end
%         plot(pf(ja,552),pf(jb,552),'*r');
%         hold on;
%         plot(pf(ja,640),pf(jb,640),'*b');
%         hold on
%         plot(pf(ja,269),pf(jb,269),'*g');
%         hold on
        xlll=strcat('f_',int2str(ja));
        ylll=strcat('f_',int2str(jb));
        xlabel(xlll);
        ylabel(ylll);
        %title('Pareto Front');
        %legend ('DMS results');
        ylim('auto');
        namefile=strcat('fig',int2str(nnn))
        saveas(figure(nnn), namefile,'fig')
        saveas(figure(nnn), namefile,'jpg')
        saveas(figure(nnn), namefile,'pdf')
        %
        %% outra figura
        nbb=ja*1000+jb;
        figure(nbb);
        plot(Flist(1,:),Flist(2,:),'.k');
        hold on;
%         plot(pf(ja,552),pf(jb,552),'*r');
%         hold on;
%         plot(pf(ja,640),pf(jb,640),'*b');
%         hold on
%         plot(pf(ja,269),pf(jb,269),'*g');
%         hold on
        xlll=strcat('f_',int2str(ja));
        ylll=strcat('f_',int2str(jb));
        xlabel(xlll);
        ylabel(ylll);
        %title('Pareto Front');
        %legend ('DMS results');
        ylim('auto');
        namefile=strcat('fig',int2str(nnn),'a')
        saveas(figure(nbb), namefile,'fig')
        saveas(figure(nbb), namefile,'jpg')
        saveas(figure(nbb), namefile,'pdf')
        %
        %% outra figura
        nbb=ja*10000+jb;
        figure(nbb);
        for ik=1:m
            if pf(ja,ik)<0
                pf(ja,ik)=-pf(ja,ik);
            end
            if pf(jb,ik)<0
                pf(jb,ik)=-pf(jb,ik);
            end
            plot(pf(ja,ik),pf(jb,ik),'.k');hold on;
        end
%         plot(pf(ja,578),pf(jb,578),'*r');
%         hold on;
%         plot(pf(ja,1066),pf(jb,1066),'*b');
%         hold on
%         plot(pf(ja,787),pf(jb,787),'*g');
%         hold on
        xlll=strcat('f_',int2str(ja));
        ylll=strcat('f_',int2str(jb));
        xlabel(xlll);
        ylabel(ylll);
        %title('Pareto Front');
        %legend ('DMS results');
        ylim('auto');
        namefile=strcat('fig',int2str(nnn),'b')
        saveas(figure(nbb), namefile,'fig')
        saveas(figure(nbb), namefile,'jpg')
        saveas(figure(nbb), namefile,'pdf')
                
    end
end
