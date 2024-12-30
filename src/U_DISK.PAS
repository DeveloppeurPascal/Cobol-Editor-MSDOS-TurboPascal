Unit U_Disk;                 { Mise … jour le 21/07/1991. }
{
Logiciel: ED_COBOL.

Auteur: Pr‚martin Patrick.
Date: 09/03/1991.
      10/03/1991.
      17/07/1991.
      21/07/1991.

But: Acc‚s aux disquettes et … l'imprimante.
}
{ $define demo_vers}
Interface

Uses
    Printer,
    U_Fenetre,
    U_Ger_Chaine,
    U_Listing,
    U_Sgf,
    U_Utilitaire,
    U_Variables;

procedure swap_file_name;
          { Cette procedure echange les noms du bloc et du fichier courant. }
Procedure Initialisation_Disk;
          { Initialisation des variables utilis‚es par cette unit‚. }
Procedure Demande_Nom_Fichier (Chaine : String);
          { Change le nom du fichier courant. }
Procedure Impression_Code_Source;
          { Listing du programme sur l'imprimante. }
procedure impression_bloc;
          { Listing d'un bloc. }

{$IFNDEF DEMO_VERS}
Procedure Sauvegarde_Code_Source;
          { Sauve le listing sur disquette ou disque dur. }
procedure sauvegarde_bloc;
          { Sauve la partie de listing contenue dans le bloc. }
{$ENDIF}

Procedure Chargement_Code_Source;
          { Charge un fichier. }
procedure chargement_bloc;
          { Charge un bloc. }

Implementation
Const
     Parametre : Boolean = False;

Var
   Nom_Fichier : String;
   nom_bloc    : string;

procedure swap_file_name;
var fich : string;
begin
     fich := nom_fichier;
     nom_fichier := nom_bloc;
     nom_bloc := fich;
end; { swap_file_name }

Procedure Initialisation_Disk;
Begin
     If ((Paramcount > 0) And Not Parametre)
     Then
         Begin
              Nom_Fichier := Paramstr (1);
              Met_Extension (Nom_Fichier, '.CBL', Nom_Fichier);
              If Exist (Nom_Fichier)
              Then
                  Chargement_Code_Source;
              {endif}
         End
     Else
         Nom_Fichier := 'NONAME.CBL';
     {endif}
     Parametre := True;
     nom_bloc := 'NONAME.BLK';
End; { initialisation_disk }

Procedure Demande_Nom_Fichier (Chaine : String);
Var
   Nom_Fich : String;
Begin
     Message_Alerte (Concat (Chaine, Nom_Fichier), False);
     Write ('Nouveau nom: ');
     Readln (Nom_Fich);
     Maj_Chaine (Nom_Fich, Nom_Fich);
     Met_Extension (Nom_Fich, '.CBL', Nom_Fich);
     If (Nom_Fich <> '.CBL')
     Then
         Nom_Fichier := Nom_Fich;
     {endif}
End; { demande_nom_fichier }

Procedure Impression_Code_Source;
Var
   I : Integer;
begin
     message_alerte ('Impression du listing en cours...', false);
     For I := 1 To Code_Source.Nb_Lig Do
         begin
              {$i-}
              Writeln (Lst, '      ', Code_Source.Lignes [I]);
              {$i+}
              if (ioresult <> 0)
              then
                  begin
                       erreur (ioresult);
                       exit;
                  end;
              {endif}
         end;
     {endfor}
End; { impression_code_source }

procedure impression_bloc;
var
   i : integer;
begin
     message_alerte ('Impression du bloc en cours...', false);
     for i := ln_deb_bloc to ln_fin_bloc do
         begin
              {$i-}
              writeln (lst, '      ', code_source.lignes [i]);
              {$i+}
              if (ioresult <> 0)
              then
                  begin
                       erreur (ioresult);
                       exit;
                  end;
              {endif}
         end;
     {endfor}
end; { impression_bloc }

Procedure Chargement_Code_Source;
Var
   Fichier : Text;
   Chaine  : String;
Begin
     if question_alerte ('Voulez-vous charger '+nom_fichier+' ?')
     then
         begin
              Message_Alerte (Concat ('Chargement de: ', Nom_Fichier), False);
              Assign (Fichier, Nom_Fichier);
              Reset (Fichier);
              If (Eof (Fichier))
              Then
                  Message_Alerte ('Fichier vide, lecture impossible.', True)
              Else
                  With Code_Source Do
                       Begin
                            Message_Alerte ('Chargement en cours...', False);
                            Nb_Lig := 0;
                            While Not ((Eof (Fichier)) Or (Nb_Lig >= Nb_Max_Ligne)) Do
                                  Begin
                                       Inc (Nb_Lig);
                                       Readln (Fichier, Chaine);
                                       Lignes [Nb_Lig] := Copy (Chaine, 7, 66)
                                  End;
                            {endwhile}
                            If (Eof (Fichier))
                            Then
                                Message_Alerte ('Chargement termin‚.', True)
                            Else
                                Begin
                                     Message_Alerte ('Ce fichier est trop long pour tenir dans mon ‚diteur.', True);
                                     Message_Alerte ('D‚sol‚, mais je ne peut pas travailler avec.', True);
                                     Halt
                                End;
                            {endif}
                       End;
                  {endwith}
              {endif}
              Close (Fichier);
              Clear_Window;
         end;
     {endif}
End; { chargement_code_source }

procedure chargement_bloc;
var
   fichier : text;
   chaine : string;
begin
     if question_alerte ('Voulez-vous charger '+nom_fichier+' ?')
     then
         begin
              met_extension (nom_fichier, '.BLK', nom_fichier);
              Message_Alerte (Concat ('Chargement de: ', Nom_Fichier), False);
              Assign (Fichier, Nom_Fichier);
              Reset (Fichier);
              If (Eof (Fichier))
              Then
                  Message_Alerte ('Fichier vide, lecture impossible.', True)
              Else
                  With Code_Source Do
                       Begin
                            Message_Alerte ('Chargement en cours...', False);
                            While Not ((Eof (Fichier)) Or (Nb_Lig >= Nb_Max_Ligne)) Do
                                  Begin
                                       Inc (Nb_Lig);
                                       Readln (Fichier, Chaine);
                                       decal_lig (nb_lig, lig);
                                       Lignes [Lig] := Copy (Chaine, 7, 66);
                                       inc (lig);
                                  End;
                            {endwhile}
                            dec (lig);
                            If (Eof (Fichier))
                            Then
                                Message_Alerte ('Chargement termin‚.', True)
                            Else
                                Begin
                                     Message_Alerte ('Ce fichier est trop long pour tenir dans mon ‚diteur.', True);
                                     Message_Alerte ('D‚sol‚, mais je ne peut pas travailler avec.', True);
                                End;
                            {endif}
                       End;
                  {endwith}
              {endif}
              Close (Fichier);
              Clear_Window;
         end;
     {endif}
end; { chargement_bloc }

{$IFNDEF DEMO_VERS}
Procedure Sauvegarde_Code_Source;
Var
   Fichier : Text;
   I       : Integer;
Begin
      if question_alerte ('Voulez-vous sauver '+nom_fichier+' ?')
      then
          begin
               Message_Alerte (Concat ('Sauvegarde de: ', Nom_Fichier), False);
               Cree_Bak (Nom_Fichier);
               Assign (Fichier, Nom_Fichier);
               {$i-}
               Rewrite (Fichier);
               {$i+}
               if (ioresult <> 0)
               then
                   erreur (ioresult)
               else
                   begin
                        With Code_Source Do
                             For I := 1 To Nb_Lig Do
                                 begin
                                      {$i-}
                                      writeln (fichier, '      ', lignes [i]);
                                      {$i+}
                                      if (ioresult <> 0)
                                      then
                                          begin
                                               erreur (ioresult);
                                               exit;
                                          end;
                                      {endif}
                                 end;
                             {endfor}
                        {endwith}
                        Close (Fichier);
                        Clear_Window;
                   end;
               {endif}
          end;
      {endif}
End; { sauvegarde_code_source }

procedure sauvegarde_bloc;
var
   fichier : text;
   i : integer;
begin
      if question_alerte ('Voulez-vous sauver '+nom_fichier+' ?')
      then
          begin
               met_extension (nom_fichier, '.BLK', nom_fichier);
               Message_Alerte (Concat ('Sauvegarde de: ', Nom_Fichier), False);
               Cree_Bak (Nom_Fichier);
               Assign (Fichier, Nom_Fichier);
               {$i-}
               Rewrite (Fichier);
               {$i+}
               if (ioresult <> 0)
               then
                   erreur (ioresult)
               else
                   begin
                        With Code_Source Do
                             For I := ln_deb_bloc To ln_fin_bloc Do
                                 begin
                                      {$i-}
                                      writeln (fichier, '      ', lignes [i]);
                                      {$i+}
                                      if (ioresult <> 0)
                                      then
                                          begin
                                               erreur (ioresult);
                                               exit;
                                          end;
                                      {endif}
                                 end;
                             {endfor}
                        {endwith}
                        Close (Fichier);
                        Clear_Window;
                   end;
               {endif}
          end;
      {endif}
end; { sauvegarde_bloc }
{$ENDIF}

End. { Fin de l'unit‚ 'U_Disk'. }
