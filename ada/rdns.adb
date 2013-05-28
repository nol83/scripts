with Ada.Text_IO; use Ada.Text_IO;
with Ada.Directories; use Ada.Directories;
with Ada.Exceptions; use Ada.Exceptions;
with Ada.Text_IO.Unbounded_IO; use Ada.Text_IO.Unbounded_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

procedure RDNS is
   type IP is array (1 .. 4) of Unbounded_String;
   File_Name : String (1 .. 40);
   Last      : Natural;
   File_In   : File_Type;
   File_Out  : File_Type;
begin
   Put ("Enter file name : ");
   Get_Line (Item => File_Name,
             Last => Last);
   Open (File => File_In,
         Mode => In_File,
         Name => File_Name (1 .. Last));
   File_Name (Last + 1 .. Last + 4) := "_rev";
   if Exists (File_Name (1 .. Last + 4)) then
      Delete_File (Name => File_Name (1 .. Last + 4));
   end if;
   Create (File => File_Out,
           Mode => Out_File,
           Name => (File_Name (1 .. Last + 4)));
   while not End_Of_File (File_In) loop
      declare
         Line   : Unbounded_String := Get_Line (File => File_In);
         Domain : Unbounded_String;
         Rev_IP : IP;
         From   : Positive := 1;
      begin
         From := Index (Source  => Line,
                        Pattern => ",") + 1;
         Domain := To_Unbounded_String (Slice (Source => Line,
                                               Low    => 1,
                                               High   => From - 2));
         Delete (Source  => Line,
                 From    => 1,
                 Through => From - 1);
         From := Index (Source  => Line,
                        Pattern => ",") + 1;
         declare
            IP_Slice : Unbounded_String := To_Unbounded_String (Source => Slice (Source => Line,
                                                                                 Low    => 1,
                                                                                 High   => From - 2));
            Dot : Natural;
         begin
            for I in reverse IP'First + 1 .. IP'Last loop
               Dot := Index (Source  => IP_Slice,
                             Pattern => ".");
               Rev_IP (I) := To_Unbounded_String (Slice (Source => IP_Slice,
                                                         Low    => 1,
                                                         High   => Dot - 1));
               Delete (Source  => IP_Slice,
                       From    => 1,
                       Through => Dot);
            end loop;
            Rev_IP (IP'First) := IP_Slice;
         end;
         for I in IP'Range loop
            Put (File => File_Out,
                 Item => Rev_IP (I) & ".");
         end loop;
         Put (File => File_Out,
              Item => "in-addr.arpa.   IN PTR    ");
         Put (File => File_Out,
              Item => Domain & ".");
         New_Line (File    => File_Out);
      end;
   end loop;
   Close (File => File_In);
   Close (File => File_Out);
exception
   when Error : others =>
      Put ("Exception: ");
      Put_Line (Exception_Name (Error));
      Put_Line (Exception_Message (Error));
      Close (File => File_In);
      Close (File => File_Out);
end RDNS;
