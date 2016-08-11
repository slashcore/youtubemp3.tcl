##############################################################################################
# Youtube to MP3 download created by : slashcore @ 2016                                       
# TCL name : youtubemp3.tcl                                                                   
# Please visit our IRC Metwork : ForumCerdasNET (irc.forumcerdas.net) @ channel #mp3.         
##############################################################################################
# Require software : youtube-dl, exiftool, httpd/apache with userdir(public_html) enabled     
##############################################################################################
# Changelog :                                                                                 
# Ver: 0.1.0811201602 @ 11/08/2016 - Added: bot status occupied or free. by: slashcore        
# Ver: 0.1.0811201603              - Added: on join notice by: slashcore                      
# Ver: 0.1.0811201604              - Added: error messages printed if any and return 0        
##############################################################################################
# Notes : - You're free to modified but keep the real credits there.                          
##############################################################################################
# Special Thanks to : (-V-) Vaksin - for the advise if any error appeared                     
##############################################################################################

# Set with your BotNickname 
set cc DL02
# Set your youtubemp3 channel
set mp3chan "#mp3"
set versi "Build Beta Ver: 0.1.0811201604"
set pattern1 http://www.youtube.com/watch*
set pattern2 https://www.youtube.com/watch*
# Set to your user home directory
set home /home/dua
# Set to your public_html folder
set webfolder /home/dua/public_html
# Set to your download URL
set dlurl "http://grabit.forumcerdas.net/~dua/"
# set to 0 (on join notice on) , 1 (on join notice off)
set notice "0"

bind pub p|p .$cc youtubedl
bind pub m|m $cc pub:bersih
bind pub p|p !ver versi
bind join - * join:mp3notice

proc youtubedl {nick uhost hand chan text} {
    global pattern1 pattern2 mp3chan dlurl webfolder home versi
    set status "0"
    if { $chan != $mp3chan } { putquick "NOTICE $nick :you're not in channel $mp3chan to use this feature. Please join $mp3chan to use it."
        return 0
        }
        set tempstatus [open "status.txt" r]
        set status [gets $tempstatus]
        close $tempstatus
    if { $status  != 0 } {
        putquick "NOTICE $nick :$nick, i'm still occupied please wait until i'm finished my job."
        return 0 }
    if { [regexp $pattern1 $text == 1] } {
        putquick "NOTICE $nick :$text matched. Going to next step..."
        putquick "NOTICE $nick :please be patient we're still processing your request."
        catch { set judul [exec youtube-dl -x --audio-format mp3 -o "%(title)s.temp" --get-filename [split $text] | sed {s/ /_/g}] } errmsgs
        # print error if any such as SME/Copyrighted blocking
    if { [regexp {^ERROR*} $errmsgs == 1] } {
        puthelp "PRIVMSG $chan :($errmsgs)"
        return 0
        }
        #input the judultext to a file
        set temp [open "judul1.txt" w+]
        puts $temp $judul
        close $temp
        # put status occupied = 1
        set tempstatus [open "status.txt" w+]
        puts $tempstatus "1"
        close $tempstatus
        #open file judul.txt to a string
        set temp [open "judul1.txt" r]
        set judultemp [gets $temp]
        set judulfinal [exec cat judul1.txt | sed {s/.temp//g} | sed {s/#//g} | sed {s/!//g} | sed {s/'//g} | sed {s/@//g}]
        close $temp
        putlog "< $nick @ $chan > is requesting download from youtube $judulfinal.mp3 ."
#       set youtube [exec youtube-dl -f 160+140 -x --audio-format mp3 -o "$webfolder/$judulfinal.%(ext)s" [split $text]]
        catch { set youtube [exec youtube-dl --audio-quality 0 -x --audio-format mp3 -o "$webfolder/$judulfinal.%(ext)s" [split $text]] }
        if { $youtube != 0 } {
        set size [exec exiftool -FileSize -s $webfolder/$judulfinal.mp3 | sed {s/ //g} | sed {s/FileSize://g}]
        set length [exec exiftool -Duration -s $webfolder/$judulfinal.mp3 | sed {s/ //g} | sed {s/Duration://g} | sed {s/(approx)//g}]
        puthelp "PRIVMSG $chan :Download URL: \00312$dlurl$judulfinal.mp3\003 | FileSize : \002$size\002 | Length : \002$length\002 |"
        puthelp "NOTICE $nick :you have only \00312(60 mins)\003 to get the file and it will be deleted after."
        puthelp "PRIVMSG $chan :This Public Service is served by: \00312ForumCerdasNET\00304@\003122016\003 \00314$versi\003"
        # put satus free = 0
        set tempstatus [open "status.txt" w+]
        puts $tempstatus "0"
        close $tempstatus
        # delete expired files in 1 hour
        after 3600000 infodel1 $judulfinal }
        } elseif { [regexp $pattern2 $text == 1] } {
        putquick "NOTICE $nick :$text matched. Going to next step..."
        putquick "NOTICE $nick :please be patient we're still processing your request."
        catch { set judul [exec youtube-dl -x --audio-format mp3 -o "%(title)s.temp" --get-filename [split $text] | sed {s/ /_/g}] } errmsgs
        # print error if any such as SME/Copyrighted blocking
    if { [regexp {^ERROR*} $errmsgs == 1] } {
        puthelp "PRIVMSG $chan :($errmsgs)"
        return 0
        }
        #input the judultext to a file
        set temp [open "judul1.txt" w+]
        puts $temp $judul
        close $temp
        # put status occupied = 1
        set tempstatus [open "status.txt" w+]
        puts $tempstatus "1"
        close $tempstatus
        #open file judul.txt to a string
        set temp [open "judul1.txt" r]
        set judultemp [gets $temp]
        set judulfinal [exec cat judul1.txt | sed {s/.temp//g} | sed {s/#//g} | sed {s/!//g} | sed {s/'//g} | sed {s/@//g}]
        close $temp
        putlog "< $nick @ $chan > is requesting download from youtube $judulfinal.mp3 ."
#       set youtube [exec youtube-dl -f 160+140 -x --audio-format mp3 -o "$webfolder/$judulfinal.%(ext)s" [split $text]]
        set youtube [exec youtube-dl --audio-quality 0 -x --audio-format mp3 -o "$webfolder/$judulfinal.%(ext)s" [split $text]]
        set size [exec exiftool -FileSize -s $webfolder/$judulfinal.mp3 | sed {s/ //g} | sed {s/FileSize://g}]
        set length [exec exiftool -Duration -s $webfolder/$judulfinal.mp3 | sed {s/ //g} | sed {s/Duration://g} | sed {s/(approx)//g}]
        puthelp "PRIVMSG $chan :Download URL: \00312$dlurl$judulfinal.mp3\003 | FileSize : \002$size\002 | Length : \002$length\002 |"
        puthelp "NOTICE $nick :you have only \00312(60 mins)\003 to get the file and it will be deleted after."
        puthelp "PRIVMSG $chan :This Public Service is served by: \00312ForumCerdasNET\00304@\003122016\003 \00314$versi\003"
        # put satus free = 0
        set tempstatus [open "status.txt" w+]
        puts $tempstatus "0"
        close $tempstatus
        # delete expired files in 1 hour
        after 3600000 infodel1 $judulfinal
        } else {
        putquick "NOTICE $nick :finding $text Going to next step..."
        catch { set judul [exec youtube-dl ytsearch:[split $text] -x --audio-format mp3 -o "%(title)s.temp" --get-filename | sed {s/ /_/g}] } errmsgs
        # print error if any such as SME/Copyrighted blocking
    if { [regexp {^ERROR*} $errmsgs == 1] } {
        puthelp "PRIVMSG $chan :($errmsgs)"
        return 0
        }
        #input the judultext to a file
        set temp [open "judul2.txt" w+]
        puts $temp $judul
        close $temp
        # put status occupied = 1
        set tempstatus [open "status.txt" w+]
        puts $tempstatus "1"
        close $tempstatus
        #open file judul.txt to a string
        set temp [open "judul2.txt" r]
        set judultemp [gets $temp]
        set judulfinal [exec cat judul2.txt | sed {s/.temp//g} | sed {s/#//g} | sed {s/!//g} | sed {s/'//g} | sed {s/@//g}]
        close $temp
        putlog "< $nick @ $chan > is requesting download from youtube $judulfinal.mp3 ."
        putquick "NOTICE $nick :Selected $judulfinal proceeding...."
#       set youtube [exec youtube-dl ytsearch:[split $text] -f 160+140 -x --audio-format mp3 -o "$webfolder/$judulfinal.%(ext)s"]
        set youtube [exec youtube-dl ytsearch:[split $text] --audio-quality 0 -x --audio-format mp3 -o "$webfolder/$judulfinal.%(ext)s"]
        set size [exec exiftool -FileSize -s $webfolder/$judulfinal.mp3 | sed {s/ //g} | sed {s/FileSize://g}]
        set length [exec exiftool -Duration -s $webfolder/$judulfinal.mp3 | sed {s/ //g} | sed {s/Duration://g} | sed {s/(approx)//g}]
        puthelp "PRIVMSG $chan :Download URL: \00312$dlurl$judulfinal.mp3\003 | FileSize : \002$size\002 | Length : \002$length\002 |"
        puthelp "NOTICE $nick :you have only \00312(60 mins)\003 to get the file and it will be deleted after."
        puthelp "PRIVMSG $chan :This Public Service is served by: \00312ForumCerdasNET\00304@\003122016\003 \00314$versi\003"
        # put satus free = 0
        set tempstatus [open "status.txt" w+]
        puts $tempstatus "0"
        close $tempstatus
        # delete expired files in 1 hour
        after 3600000 infodel2 $judulfinal
        }
}

proc infodel1 {judulfinal} {
    global mp3chan webfolder home
    exec rm -rf $webfolder/$judulfinal.mp3
    puthelp "PRIVMSG $mp3chan :\00304$judulfinal.mp3\003 is expired and deleted."
    putlog "< files expired > $judulfinal.mp3 is expired and deleted."
}

proc infodel2 {judulfinal} {
    global mp3chan webfolder home
    exec rm -rf $webfolder/$judulfinal.mp3
    puthelp "PRIVMSG $mp3chan :\00304$judulfinal.mp3\003 is expired and deleted."
    putlog "< files expired > $judulfinal.mp3 is expired and deleted."
}

proc pub:bersih {nick uhost hand chan arg} {
        global home mp3chan
        set cmd [lindex $arg 0]
        switch -- $cmd  {
                "clear" {
                if { $chan != $mp3chan } {
                putlog "< $nick @ $chan > !WARNING! is trying to use CLEAR but not in $mp3chan"
                return 0
                } else {
                putlog "< $nick @ $chan > !CLEAR! is clearing public_html."
                after 2000 [exec $home/sapu.sh]
                puthelp "NOTICE $nick :files clearing is done."
                }
        }
    }
}

proc join:mp3notice {nick uhost hand chan} {
        global mp3chan cc notice
        if { $notice != 1 } { return 0 }
        if { $chan == $mp3chan} {
                putquick "NOTICE $nick :Bot available \002DL01 & DL02\002 Download MP3 from Youtube use \002.botnick <youtube url/artist - song title>.\002"
                putquick "NOTICE $nick :Example Usage: \00312.$cc http://www.youtube.com/watch?v=h1e4q9LLTA0\003 or \00312.$cc Kla Project - Yogyakarta\003"
        } else {
                return 0
        }
}

proc versi {nick uhost hand chan args} {
        global versi
        putlog "< $nick @ $chan > !Version!"
        puthelp "PRIVMSG $chan :$nick : MP3 Youtube Download Conversion by \002slashcore\002 (\00314$versi\003)"
}

putlog  "ForumCerdas YouTube to MP3 download & converter by \002slashcore\002 @ 2016 loaded. (\00314$versi\003)"

