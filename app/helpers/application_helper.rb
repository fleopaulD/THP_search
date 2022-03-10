module ApplicationHelper
  
  STOPWORDS = %w[abord absolument afin ah ai aie aient aies ailleurs ainsi ait allaient allo allons alors anterieur anterieure anterieures apres as assez attendu au aucun aucune aucuns aujourd aujourd hui aupres auquel aura aurai auraient aurais aurait auras aurez auriez aurions aurons auront aussi autant autre autrefois autrement autres autrui aux auxquelles auxquels avaient avais avait avant avec avez aviez avions avoir avons ayant ayez ayons bah bas basee bat beau beaucoup bien bigre bon boum bravo brrr car ce ceci cela celle celleci cellela celles cellesci cellesla celui celuici celuila cent cependant certain certaine certaines certains certes ces cet cette ceux ceuxci ceuxla chacun chacune chaque cher chers chez chiche chut chere cheres ci cinq cinquantaine cinquante cinquantieme cinquieme clac clic combien comme comment comparable comparables compris concernant contre couic crac da dans de debout dedans dehors deja dela depuis dernier derniere derriere des desormais desquelles desquels dessous dessus deux deuxieme deuxiemement devant devers devra devrait different differentes differents differente dire directe directement dit dite dits divers diverse diverses dix dixhuit dixneuf dixsept dixieme doit doivent donc dont dos douze douzieme dring droite du duquel durant debut effet egale egalement egales eh elle ellememe elles ellesmemes en encore enfin entre envers environ es essai est et etant etc etre eu eue eues euh eurent eus eusse eussent eusses eussiez eussions eut eux euxmemes exactement excepte extenso exterieur eumes eut eutes fais faisaient faisant fait faites façon feront fi flac floc fois font force furent fus fusse fussent fusses fussiez fussions fut fumes fut futes gens ha haut hein hem hep hi ho hola hop hormis hors hou houp hue hui huit huitieme hum hurrah he helas ici il ils importe je jusqu jusque juste la laisser laquelle las le lequel les lesquelles lesquels leur leurs longtemps lors lorsque lui luimeme ma maint maintenant mais malgre maximale me meme memes merci mes mien mienne miennes miens mille mince mine minimale moi moimeme moindres moins mon mot moyennant multiple multiples na naturel naturelle naturelles ne neanmoins necessaire necessairement neuf neuvieme ni nombreuses nombreux nommes non nos notamment notre nous nousmemes nouveau nouveaux nul notre notres oh ohe olle ole on ont onze onzieme ore ou ouf ouias oust ouste outre ouvert ouverte ouverts ou paf pan par parce parfois parle parlent parler parmi parole parseme partant particulier particuliere particulierement pas passe pendant pense permet personne personnes peu peut peuvent peux pff pfft pfut pif pire piece plein plouf plupart plus plusieurs plutot possessif possessifs possible possibles pouah pour pourquoi pourrais pourrait pouvait prealable precisement premier premiere premierement pres probable probante procedant proche psitt pu puis puisque pur pure qu quand quant quantasoi quanta quarante quatorze quatre quatrevingt quatrieme quatriemement que quel quelconque quelle quelles quelqu un quelque quelques quels qui quiconque quinze quoi quoique rare rarement rares relative relativement remarquable rend rendre restant reste restent restrictif retour revoici revoila rien sa sacrebleu sait sans sapristi sauf se sein seize selon semblable semblaient semble semblent sent sept septieme sera serai seraient serais serait seras serez seriez serions serons seront ses seul seule seulement si sien sienne siennes siens sinon six sixieme soi soimeme soient sois soit soixante sommes son sont sous souvent soyez soyons specifique specifiques speculatif stop strictement subtiles suffisant suffisante suffit suis suit suivant suivante suivantes suivants suivre sujet superpose sur surtout ta tac tandis tant tardive te tel telle tellement telles tels tenant tend tenir tente tes tic tien tienne tiennes tiens toc toi toimeme ton touchant toujours tous tout toute toutefois toutes treize trente tres trois troisieme troisiemement trop tsoin tsouin tu un une unes uniformement unique uniques uns va vais valeur vas vers via vif vifs vingt vivat vive vives vlan voici voie voient voila voire vont vos votre vous vousmemes vu ve votre votres zut ça etaient etais etait etat etiez etions ete etee etees etes]
  
  def cleanup_string(string)
    cleaned_string = []
    string = string.join(" ") if string.is_a? Array
    string.split(/ |'/) do |word|
      word = word.downcase.gsub(/[^[:alpha:]]/, '').gsub(/[éèëê]/, 'e').gsub(/[àâä]/, 'a'.gsub(/[ôòö]/, 'o').gsub(/[ûùü]/, 'u'))
      next if word.length < 2
      next if STOPWORDS.include? word
      cleaned_string << word
    end
    cleaned_string.join(" ")
  end
  
  def word_counter(content)
    words = {}
    cleanup_string(content).split(" ").each do |word|
      words[word].nil? ? words[word] = 1 : words[word] += 1
    end
    words
  end

end
