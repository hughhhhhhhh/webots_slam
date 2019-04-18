close all;
clear all;
clc;
% [t,I] = RIR(0.1,0.2,0.3);
% [w,h]=size;
      [yellowpos1,yellowpos2,yellowpos3,yellowpos4] = obstaclePosition([-0.12,-0.883,0.14],[0.5,0.14],-4.7)
%      X = sprintf('%.4f  %.4f  %.4f  %.4f',yellowpos1,yellowpos2,yellowpos3,yellowpos4,1,1,1,-1,-1,-1);
% disp(X)
[t,I] = RIR(-0.327,0.247,0,yellowpos1,yellowpos2,yellowpos3,yellowpos4,1,1,1,-1,-1,-1);
displayRoom('testfile','HideVS');   

% load ('testfile','R_ind','S_coord','AW','S_Ex','mR');
% 
% 
%     
%     colormap(hot)
%     C = colormap;
%     NColor = size(C,1)-15;
% 
%    
%         op = 'none';
% 
%     
%         mR=0;
%    
%     
%      for r=0:mR;
%         plot3(S_coord(1,R_ind==r),S_coord(2,R_ind==r),S_coord(3,R_ind==r)...
%         ,'o','markersize',18-12*r/(mR+1),'markeredgecolor',[0 0 0],'markerfacecolor',...
%         C(round(NColor*(r+1)/(mR+1)),:))
%         hold on
%      end
%      grid on;
%      
%      
%      
%      for r=1:size(S_coord,2);
%          if(strcmp(op,'HideVS'))
%              if(R_ind(r)==0)
%                  line([S_coord(1,r) S_coord(1,r)+S_Ex(1,r)],[S_coord(2,r) S_coord(2,r)+S_Ex(2,r)],...
%                      [S_coord(3,r) S_coord(3,r)+S_Ex(3,r)],'Color',C(round(NColor*(R_ind(r)+1)/(mR+1)),:),...
%                      'LineWidth',2,'Marker','.','MarkerSize',16,'MarkerFaceColor',C(round(NColor*(R_ind(r)+1)/(mR+1)),:));
%              end
%              
%          else
%              
%              
%              line([S_coord(1,r) S_coord(1,r)+S_Ex(1,r)],[S_coord(2,r) S_coord(2,r)+S_Ex(2,r)],...
%                  [S_coord(3,r) S_coord(3,r)+S_Ex(3,r)],'Color',C(round(NColor*(R_ind(r)+1)/(mR+1)),:),...
%                  'LineWidth',2,'Marker','.','MarkerSize',16,'MarkerFaceColor',C(round(NColor*(R_ind(r)+1)/(mR+1)),:));
%          end
%      end
%      
%      N_Sur = size(AW,2);
%      
%      colormap(hsv)
%     C = colormap;
%     NColor = size(C,1);
%     
%     for n = 1:N_Sur;
%         fill3([AW(n).P1(1) AW(n).P2(1) AW(n).P3(1) AW(n).P4(1)],...
%               [AW(n).P1(2) AW(n).P2(2) AW(n).P3(2) AW(n).P4(2)],...
%               [AW(n).P1(3) AW(n).P2(3) AW(n).P3(3) AW(n).P4(3)],...
%               C(round(NColor*n/N_Sur),:),'FaceAlpha',0.4,...
%               'EdgeColor',[1,1,1],'EdgeAlpha',0.6)
%     end
%         
%         xlabel('x','FontSize',14,'FontName','Courier New');
%         ylabel('y','FontSize',14,'FontName','Courier New');
%         zlabel('z','FontSize',14,'FontName','Courier New');
%         set(axes,'FontSize',14,'FontName','Courier New','Box','off','FontAngle','italic');
%         axis equal


% plot(1000*t,abs(I))
% ylabel('Amplitude')
% xlabel('Time (ms)')
% legend('Source 1','Source 2','Source 3')
