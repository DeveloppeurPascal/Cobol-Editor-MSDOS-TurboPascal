Unit U_Informations;         { Mise … jour le 21/07/1991. }
{
Logiciel: ED_COBOL.

Auteur: Pr‚martin Patrick.
Date: 09/03/1991. 10/03/1991. 18/07/1991. 20/07/1991. 21/07/1991.

But: Affichage des ‚crans d'aide.
}
{ $define demo_vers}
Interface

Uses
    Crt,
    U_Utilitaire,
    U_Aff_Chaine,
    U_Fenetre;

Procedure Informations;
          { Affichage des ‚crans d'aide du logiciel. }

Implementation
Procedure Set_Cadre_Infos (Titre_Page : String);
Begin { set_cadre_infos }
  Reset_Screen;
  Type_Cadre := 6;
  Window_Fond_Cadre_Bis (2, 2, 79, 23, Blue, Lightgray, Black);
  Window_Titre ('Editeur de fichiers sources Cobol.', Lightblue+Blink, Brown);
  Textcolor (Yellow);
  Textbackground (Blue);
  Affic_Center_Ln ('Ecrans d''aide:');
  Affic_Center_Ln (Titre_Page);
  Writeln
End; { set_cadre_infos }

Procedure Informations;
Begin { informations }
{$IFDEF DEMO_VERS}
{ Page 0: confirmation de la d‚mo. }
  set_cadre_infos ('Page 0: Version de d‚monstration.');
  writeln ('   Ce programme est la version de d‚monstration de ED_COBOL.');
  writeln;
  writeln ('   La seule restriction faite … la version d‚finitive sont');
  writeln ('les sauvegardes que j''ai supprim‚es. Sinon, le programme');
  writeln ('fonctionne normalement.');
  writeln;
  attente_appuit_touche;
{$ENDIF}

{ Page 1: gestion du menu. }
  Set_Cadre_Infos ('Page 1: Touches de fonction.');
  writeln ('      F1 Affichage des ecrans d''aide.');
  writeln ('      F2 Sauvegarde du listing.');
  writeln ('      F3 Chargement d''un nouveau listing.');
  writeln ('      F4 Impression du listing.');
  writeln ('      F5 Nouveau listing.');
  writeln ('      F6 DOS Shell.');
  writeln;
  Attente_Appuit_Touche;

{ Page 2: deplacements dans l'editeur. }
  Set_Cadre_Infos ('Page 2: D‚placements dans l''‚diteur.');
  Writeln ('     Utilisez les flŠches pour d‚placer le curseur.');
  writeln ('     Ctrl+FlŠche Gauche   pour aller sur le mot precedent.');
  writeln ('     Ctrl+FlŠche Droite   pour aller sur le mot suivant.');
  Writeln ('     PgUp                 pour monter d''un ‚cran.');
  writeln ('     Ctrl+PgUp            pour aller au debut du listing.');
  Writeln ('     PgDn                 pour descendre d''un ‚cran.');
  writeln ('     Ctrl+PgDn            pour aller … la fin du listing.');
  Writeln ('     Home                 pour aller en d‚but de ligne.');
  Writeln ('     End                  pour aller en fin de ligne.');
  Writeln ('     Tab ou ^I            pour passer entre les marges A et B, puis pour');
  Writeln ('                     sauter … la tabulation suivante.');
  writeln;
  attente_appuit_touche;

{ Page 3: gestion de l'editeur. }
  Set_cadre_infos ('Page 3: Gestion de l''‚diteur.');
  Writeln ('     Suppr                pour effacer le caractŠre courant.');
  Writeln ('     Backspace            pour effacer le caractŠre pr‚c‚dent.');
  Writeln ('     Enter                pour ins‚rer une ligne … la position courante.');
  Writeln ('     ^Y                   pour effacer la ligne courante.');
  Writeln ('     Ins                  pour changer le mode INSERT.');
  Writeln ('     F10                  pour changer le mode INDENT.');
  Writeln ('     ^T                   pour changer le mode TIME.');
  Writeln ('     ^D                   pour changer le mode DATE.');
  writeln ('     Alt+X ou ESC         pour quitter ce programme.');
  Writeln;
  Attente_Appuit_Touche;

{ Page 4: gestion des blocs. }
  Set_cadre_infos ('Page 4: Gestion des blocs.');
  writeln ('     Vous pouvez maintenant realiser diverses operations sur des blocs');
  writeln ('il vous suffit de frapper ^K pour acceder au controle des blocs.');
  writeln ('Voici les commandes que vous pouvez utiliser:');
  writeln ('      ^KB marque de debut de bloc.');
  writeln ('      ^KK marque de fin de bloc.');
  writeln ('      ^KC copie du bloc sur la ligne du curseur.');
  writeln ('      ^KV d‚placement du bloc vers la ligne du curseur.');
  writeln ('      ^KY effacement du bloc.');
  writeln ('      ^KR lecture d''un bloc sur disque.');
  writeln ('      ^KW ecriture d''un bloc sur disque.');
  writeln ('      ^KP impression d''un bloc.');
  writeln ('      ^KH cache un bloc.');
  writeln;
  attente_appuit_touche;

{ Page 5: messages divers. }
  Set_Cadre_Infos ('Page 5: Messages divers.');
  writeln ('     Je vous recommande fortement de sauver votre fichier avant chaque');
  writeln ('appel du DOS Shell. Ce n''est pas que je ne fasse pas confiance … mon');
  writeln ('programme, mais il faut se mefier de la place prise en m‚moire...');
  writeln;
  Writeln ('     Vous pouvez lancer ce programme en lui sp‚cifiant le nom du fichier');
  Writeln ('que vous d‚sirez modifier, s''il n''existe pas, ce programme le cr‚era...');
  Writeln;
  writeln ('     Pour tous renseignements concernant ce programme, contactez_moi:');
  Writeln;
  Writeln ('                      PREMARTIN PATRICK');
  Writeln;
  Writeln ('                  LOTISSEMENT LE SOULEIADOU');
  Writeln ('                        13790 ROUSSET');
  Writeln ('                            FRANCE');
  Writeln;
  Attente_Appuit_Touche;
  Clear_Window
End; { informations }

End. { Fin de l'unit‚ 'U_Informations'. }
