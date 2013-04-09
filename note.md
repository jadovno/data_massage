# Белешке

## Године

Можда да се године одвоје, на два дела: године и месеци?

Неке од жртава су мање од годину дана старе. А старост свих жртава се
води под називом "старост" где су године и месеци измешани.

Мој предлог је да се направе две нове колоне: "године" и "месеци".

У тим колонама да се уносе само бројне вредности, без "г.", "г",
"године", "месеци"...

## Да се не уноси HTML

Да се податци чувају у основној форми, без икаквог означавања (HTML,
XML, ...). Вредности као адресе презентација (URL) и електронске
адресе, "имејлови" (нешто@нешто.срб), могу да се унесу онакве какве
јесу, па приликом приказивања, да се претворе у одговарајући облик,
тј. да им се дода "<a href..." путем апликације која их извалчи из
базе.

Исто важи и за вредности унете као: \"нешто\".

Још један разлог против означавања: податке које сте ми дали садрже
информације о 10,502 жртве. Ако покушам да унесем те податке пре
предходног "масирања", тј. уклањања означавања, ја могу да унесем
негде око 10,400, оних 100+ "процуре"...

Ако имамо податке у основној форми они могу лако бити прилагођени за
приказивање на разни начин. Нико не мора да их "чисти" за своју
употребу.

## Пол жртава

Уместо да пише националност "Србин"/"Српкиња", ... да се унесе само
"Српска", "Јеврејска", ... а да се створи посебна колона за пол и у њу
да се унесе "м"/"ж"?

Разлог је зато што на тај начин ако би неко хтео да извуче из базе све
жртве одређеног пола, то би било лакше изводљиво.

Теоретски и сада то може да се уради, али морају да се наведу све
националности које су тренутно у бази. А шта ако се једна заборави? На
овај горе наведен начин, јасније се преузима само по полу уместо да се
памте све националности.

## Свештенство

За свештенство, под колоном "град" унето је:

'grad: "Arhijereji, monaštvo i sveštenstvo SPC"'

Било би пожељно да се дода још једна колона "свештенство" и да буде
boolean вредност. Тј. да само садржи "да" ако жртва јесте архијереј,
монах или свештеник.

## Локација

Уместо "град", да се колона можда зове "локација", јер нека од места
где су жртве живеле су села.

## Имена одређених локација

За неке од жртава наведена места рођења су:
"grad":"Gospić-Perušić". Тј. два места су означена.

Како тачно приказати ово на мапи, као Госпић или као Перушић?