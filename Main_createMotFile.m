%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% hans.kainz@univie.ac.at
% September 2020
% this code creates .mot files with joint angles stored in a c3d file (e.g.
% joint angles from the conventional gait model)
% the .mot file can be used in OpenSim to calculate muscle-tendon length 
% please cite following paper when using this code:
% Kainz and Schwartz (2021) The importance of a consistent workflow to estimate muscle-tendon lengths based on
% joint angles from the conventional gait model. Gait & Posture.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; clc; close all;
% add btk folder to path
folder = [pwd '\BTK'];
addpath(genpath(folder));
% define reference OpenSim model
model_ref = 'gait2392_PiGpelvisFrame3DoFkneeNoTorso.osim';
% define relevant angles in OpenSim model for the right leg (change if you use a different model)
angleSet_OpenSim_Model = {'hip_flexion_r' 'hip_adduction_r' 'hip_rotation_r' 'knee_flexion_r' 'knee_adduction_r' 'knee_rotation_r' 'ankle_angle_r' 'subtalar_angle_r'};
% define correspnding angles from c3d file (change is the names are different in your
% files)
angleSet_Clinical_Model = {'RHipAngles' 'RKneeAngles' 'RAnkleAngles'};
% load c3d file
            fileName = 'test.c3d' % change name and path if needed
            dataC3D = btk_loadc3d(fileName); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%% get model coordinates from OpenSim reference model
            import org.opensim.modeling.*;
            model = Model(model_ref);
            num = model.getNumCoordinates();            
            cordSet= model.getCoordinateSet();
            for n = 0:(num-1)
                Coord_model = cordSet().get(n);
                JavaString = Coord_model.getName();
                nn=n+1;
                ModelCoordinates(nn,1) = string(JavaString);
                clear Coord_model; clear JavaString;
            end
%% create empty mot file   
            motfile.time = dataC3D.marker_data.Time;
            f = length(motfile.time); % frames
            for cord = 1:length(ModelCoordinates) % add all coordinates to file with a value of zero     
                motfile.(ModelCoordinates(cord))(1:f,1) = 0;                
            end
%% add hip, knee and ankle kinematics from the c3d file to the .mot file
            for updCord = 1:length(angleSet_OpenSim_Model)
                if updCord < 4
                CGMnum = 1;
                motfile.(char(angleSet_OpenSim_Model(updCord))) = dataC3D.angles.(char(angleSet_Clinical_Model(CGMnum)))(:,updCord);
                else
                    if updCord < 7
                    CGMnum = 2;
                    updCord2 = updCord - 3;
                    motfile.(char(angleSet_OpenSim_Model(updCord))) = dataC3D.angles.(char(angleSet_Clinical_Model(CGMnum)))(:,updCord2);
                    else
                        if updCord == 7
                        CGMnum = 3;
                        updCord2 = 1;
                        motfile.(char(angleSet_OpenSim_Model(updCord))) = dataC3D.angles.(char(angleSet_Clinical_Model(CGMnum)))(:,updCord2);
                        else
                            if updCord == 8
                            CGMnum = 3;
                            updCord2 = 3;
                            motfile.(char(angleSet_OpenSim_Model(updCord))) = dataC3D.angles.(char(angleSet_Clinical_Model(CGMnum)))(:,updCord2);
                            else
                            end
                        end
                    end
                end                     
            end
 %% same for left leg
        % change name to left side
        for a = 1:length(angleSet_OpenSim_Model)
            angleSet_OpenSim_Model{1,a} = ([angleSet_OpenSim_Model{1,a}(1:end-1) 'l']); 
        end
        for a = 1:length(angleSet_Clinical_Model)
            angleSet_Clinical_Model{1,a} = (['L' angleSet_Clinical_Model{1,a}(2:end)]); 
        end
       % add hip, knee and ankle kinematics from the c3d file to the .mot file
            for updCord = 1:length(angleSet_OpenSim_Model)
                if updCord < 4
                CGMnum = 1;
                motfile.(char(angleSet_OpenSim_Model(updCord))) = dataC3D.angles.(char(angleSet_Clinical_Model(CGMnum)))(:,updCord);
                else
                    if updCord < 7
                    CGMnum = 2;
                    updCord2 = updCord - 3;
                    motfile.(char(angleSet_OpenSim_Model(updCord))) = dataC3D.angles.(char(angleSet_Clinical_Model(CGMnum)))(:,updCord2);
                    else
                        if updCord == 7
                        CGMnum = 3;
                        updCord2 = 1;
                        motfile.(char(angleSet_OpenSim_Model(updCord))) = dataC3D.angles.(char(angleSet_Clinical_Model(CGMnum)))(:,updCord2);
                        else
                            if updCord == 8
                            CGMnum = 3;
                            updCord2 = 3;
                            motfile.(char(angleSet_OpenSim_Model(updCord))) = dataC3D.angles.(char(angleSet_Clinical_Model(CGMnum)))(:,updCord2);
                            else
                            end
                        end
                    end
                end                     
            end
%% create and save motion (.mot) file
            MotFileName = [(fileName(1:end-4)) '.mot'];
            MotFileName(MotFileName == ' ') = ['_']; % replace space by '_'
            write_sto_file(motfile, MotFileName);      

