# <img src="https://github.com/user-attachments/assets/7197fdf3-4929-46e3-a2c2-4614abc6c031" alt width="100px"> reFilc"+"

### A funkciók gyűjteménye, ami ~~csak reFilc+ előfizetők számára elérhető~~ mindenki számára elérhető!

Ez a verzió **NEM** sérti az **[AGPL](https://github.com/QwIT-Development/app-legacy/blob/master/LICENSE)** licenszt, ami alatt van az alkalmazás, ellentétben a [korábbi verziójával](https://github.com/refilc/naplo/).

Korábbi verzió:<br>
![image](https://github.com/user-attachments/assets/170dc789-bb7e-449f-8aca-5a767d1097e8)<br>
([repo](https://github.com/refilc/naplo-plus/))

Ha a projekt AGPL licenc alatt van terjesztve, akkor a teljes forráskódnak, beleértve a **nélkülözhetetlen** részeket is, nyíltnak kell lennie. Ha ez nem lehetséges, akkor a projekt nem terjeszthető **AGPL** licenc alatt.

ui.: *A "fixed plus bypass" (8583609abbd6a93ac55ecff93c886d0898f71f12) nevű commit nem ér semmit, mert még mindig ugyan úgy be lehet aktiválni az appot, de lehet próbálkozni...*

### Működés

A működése az rf+-nak elég egyszerű, vannak scopek és a szervernek vissza kell adnia azt.\
Viszont amikor írták hagytak benne egy *all* scopet, ami minden funkciót felold (`refilc.plus.*`)\
A fél auth.dart kódot meggyilkolva skippelni lehet az egész rf apit, hogy állandóan * scopet adjon vissza, ezzel aktiválva az appot. (take notes)\
Ha mindenhova hardcodelve lett volna az auth, akkor *talán* ez a bypass nem működött volna. (jaj ne, de akkor leakelve lett volna az auth és megintcsak működött volna)\
**Ez az ára az open sourcenak.** Legalább tudnak segíteni az emberek a fejlesztésben.
