Unit U_Utilitaire;           { Mise … jour le 18/07/1991. }
{
Logiciel: ED_COBOL.

Auteur: Pr‚martin Patrick.
Date: 10-03-1991.
      18/07/1991.

But: regroupement de proc‚dures simplifiant la vie de l'utilisateur.
}
{ $define demo_vers}
Interface

Uses
    Crt,
    U_Aff_Chaine,
    U_Fenetre,
    U_Sgf;

Procedure Vide_Tampon_Clavier;
          { Cette proc‚dure vide le tampon du clavier. }
Procedure Attente_Appuit_Touche;
          { Cette proc‚dure attend l'appuit d'une touche. }
Procedure Message_Alerte (Chaine : String; Attente_Touche : Boolean);
          { Cette procedure affiche un message et attend eventuellement. }

Function Question_Alerte (Chaine : String): Boolean;
         { Cette fonction est vraie si l'utilisateur choisi Oui … la question
         posee. }

Implementation

Procedure Vide_Tampon_Clavier;
Var Carac : Char;
Begin { vide_tampon_clavier }
  While (Keypressed) Do
    Carac := Readkey
  {endwhile}
End; { vide_tampon_clavier }

Procedure Attente_Appuit_Touche;
Var Old_Textattr : Byte;
    Carac        : Char;
Begin { attente_appuit }
  Vide_Tampon_Clavier;
  Old_Textattr := Textattr;
  Textcolor (White);
  Textbackground (Black);
  Affic_Center ('Appuyez sur une touche');
  Vide_Tampon_Clavier;
  Carac := Readkey;
  Vide_Tampon_Clavier;
  Textattr := Old_Textattr
End; { attente_appuit }

Procedure Message_Alerte (Chaine : String; Attente_Touche : Boolean);
Var Old_Textattr : Integer;
Begin { message_alerte }
  Old_Textattr := Textattr;
  Type_Cadre := 2;
  Window_Cadre_Bis (2, 2, 79, 2, Red, Blue);
  Window_Titre (Chaine, White, Blue);
  Textbackground (Black);
  Clrscr;
  If (Attente_Touche)
  Then
    Begin
      Attente_Appuit_Touche;
      Clear_Window
    End
  {endif};
  Textattr := Old_Textattr
End; { message_alerte }

Function Question_Alerte (Chaine : String): Boolean;
Var Carac : Char;
Begin { question_alerte }
  Vide_Tampon_Clavier;
  Type_Cadre := 2;
  Window_Fond_Cadre_Bis (2, 2, 79, 2, Black, Red, Blue);
  Window_Titre (Chaine, White, Blue);
  Affic_Center ('Votre choix (Oui / Non) ?');
  Repeat
    Carac := Upcase (Readkey);
    Write (Carac);
    Gotoxy (Pred (Wherex), Wherey)
  Until ((Carac = 'O') Or (Carac = 'N'));
  Clear_Window;
  Question_Alerte := (Carac = 'O');
  Vide_Tampon_Clavier
End; { question_alerte }

End. { Fin de l'unit‚ 'U_Utilitaire'. }
