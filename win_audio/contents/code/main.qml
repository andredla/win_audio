import QtQuick 2.0
import org.kde.plasma.core 2.0 as PlasmaCore;
import org.kde.plasma.components 2.0 as Plasma;
import org.kde.kwin 2.0;

/*
kwinscript:
plasmapkg2 --type kwinscript -i .
plasmapkg2 --type kwinscript -u .
*/

Item {
    id: root
    property var win_open_sound: ["", 0]
    property var win_close_sound: ["", 0]
    property var win_max_sound: ["", 0]
    property var win_unmax_sound: ["", 0]
    property var win_min_sound: ["", 0]
    property var win_unmin_sound: ["", 0]
    property var win_res_sound: ["", 0]
    property var win_active_sound: ["", 0]
    property var desk_change_sound: ["", 0]
    
    
    PlasmaCore.DataSource {
        id: shell
        engine: 'executable'

        connectedSources: []
        
        function run(cmd){
            shell.connectSource(cmd);
        }

        function audio(cmd) {
            shell.connectSource("paplay --volume="+(65536 * cmd[1] / 100)+" "+cmd[0]);
        }

        onNewData: {
            shell.disconnectSource(sourceName);
        }
    }
    
    function win_type_normal(client){
        var ret = false;
        if(client.minimizable && client.closeable && client.maximizable && client.resizeable && client.moveable && client.moveableAcrossScreens){
            if(!client.modal && !client.specialWindow && !client.transient && !client.dialog && !client.notification && !client.popupWindow){
                ret = true;
            }
        }
        print(ret);
        return ret;
    }

    function win_open(client){
        if(win_type_normal(client)){
            shell.audio(win_open_sound);
        }
    }
    
    function win_close(client){
        if(win_type_normal(client)){
            shell.audio(win_close_sound);
        }
    }
    
    function win_max(client, h, v){
        if(win_type_normal(client)){
            if (h && v) {
                shell.audio(win_max_sound);
            }else{
                shell.audio(win_unmax_sound);
            }
        }
    }
    
    function win_min(client){
        if(win_type_normal(client)){
            shell.audio(win_min_sound);
        }
    }
    
    function win_unmin(client){
        //if(win_type_normal(client)){
            shell.audio(win_unmin_sound);
        //}
    }
    
    function win_res(client){
        if(win_type_normal(client)){
            shell.audio(win_res_sound);
        }
    }
    
    function win_active(client){
        if(win_type_normal(client)){
            shell.audio(win_active_sound);
        }
    }
    
    function desk_change(desk, client){
        shell.audio(desk_change_sound);
        shell.run("wmctrl -R 'Picture-in-Picture'");
    }
    

    function readTextFile(fileUrl){
       var xhr = new XMLHttpRequest;
       xhr.open("GET", fileUrl); // set Method and File
       xhr.onreadystatechange = function () {
           if(xhr.readyState === XMLHttpRequest.DONE){ // if request_status == DONE
               var response = xhr.responseText;
               //print(response);
               var spt = response.split("\n");
               for(var a=0; a<spt.length; a++){
                   var linha = spt[a];
                   var key = linha.split(":")[0];
                   var values = linha.split(":")[1].split(",");
                   if(key == "win_open_sound"){ root.win_open_sound = [values[0], values[1]]; }
                   if(key == "win_close_sound"){ root.win_close_sound = [values[0], values[1]]; }
                   if(key == "win_max_sound"){ root.win_max_sound = [values[0], values[1]]; }
                   if(key == "win_unmax_sound"){ root.win_unmax_sound = [values[0], values[1]]; }
                   if(key == "win_min_sound"){ root.win_min_sound = [values[0], values[1]]; }
                   if(key == "win_unmin_sound"){ root.win_unmin_sound = [values[0], values[1]]; }
                   if(key == "win_res_sound"){ root.win_res_sound = [values[0], values[1]]; }
                   if(key == "win_active_sound"){ root.win_active_sound = [values[0], values[1]]; }
                   if(key == "desk_change_sound"){ root.desk_change_sound = [values[0], values[1]]; }
               }
           }
       }
       xhr.send(); // begin the request
    }
    
    
    Component.onCompleted: {
        readTextFile("config.txt");
        /*workspace.currentDesktop = 2;*/
        workspace.clientAdded.connect(win_open);
        workspace.clientRemoved.connect(win_close);
        workspace.clientMaximizeSet.connect(win_max);
        workspace.clientMinimized.connect(win_min);
        workspace.clientUnminimized.connect(win_unmin);
        workspace.clientRestored.connect(win_res);
        workspace.clientActivated.connect(win_active);
        workspace.currentDesktopChanged.connect(desk_change);
    }

}
