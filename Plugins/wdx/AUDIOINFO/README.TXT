AudioInfo content plugin for TotalCmd 6.5+
------------------------------------------
This plugin can show information about audio files: currently supported
are MPEG (MP3/MP2/MP1), OGG, WMA, WAV, VQF, AAC, APE, MPC.
The following information is shown:

MPEG, MPC:
  Info: Channels, Duration, Sample rate, Bit rate;
  ID3v1/ID3v2 tags: Title, Artist, Album, Track, Year(Date), Genre, Comment,
  Encoder(Vendor), Composer.  If file contains both tags, V2 is used;
OGG, WMA, AAC, APE:
  Info: same;
  Tags: Title, Artist, Album, Track, Date, Genre, Comment, Vendor;
VQF:
  Info: same;
  Tags: Title, Author(Artist), Album, Comment, Copyright(Vendor);
WAV:
  Info: Channels, Duration, Sample rate, Bit rate, Format(Comment).


Installation
------------
1. Archive contains "installation file" for TC, so just open archive
   and TC will install plugin.

2. Goto Options->Custom columns;
   select some view (#N) and add several columns to it;
   for each column press "+" and select some field from AudioInfo list.
   For example, I recommend to add fields:

   Artist, Title, Album, Track, Duration.

3. Turn on custom view:
   Show->Custom columns->#N;
   go to music folder and enjoy! :-)


Versions changes
----------------
07.05.05: added MPC support
05.05.05: fixed WMA support, plugin size decreased
09.02.04: added APE support
30.01.05: fixed time display when duration>1hr;
          added field "Duration (H/M/S)"
03.11.04: info and tags for MPEG, WAV, WMA, AAC, VQF
27.10.04: duration shown in H:M:S, bitrate in Kbps, sample rate in Hz/HKz,
          plugin size decreased
26.10.04: initial version supported OGG

This plugin compiled by Alexey Torgashin.
Audio Tools Library (c) by Jurgen Faul (http://jfaul.de/atl),
ported to KOL by Dmitry Matveev (http://www.mdvkol.narod.ru).
http://totalcmd.net/plugring/AudioInfo.html
