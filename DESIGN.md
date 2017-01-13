# Design Document: Plantastic
### Barbara Boeters - 10774513
### Programmeerproject 

### Controllers:
1. RegisterViewController
2. MyGardenViewController
3. AddPlantViewController

### RegisterViewController
De RegisterViewController bestaat uit een view met twee text fields waarmee je met behulp van een username en wachtwoord je kan registreren. Er zal enkel een sign up button zijn in plaat van een log in en log out functie. De gebruiker zal de app installeren en in één keer registreren waardoor een log in en log out functie overbodig zouden zijn. Het registeren wordt gedaan met behulp van Firebase. Er zal dus een class aangemaakt moeten worden met de username en uid van de gebruiker. Verder is er een button nodig die pas naar de volgende view gaat wanneer de gebruiker de text fields correct heeft ingevuld. Voor het implementeren van Firebase zal ik de volgende tutorial gebruiken: https://www.raywenderlich.com/139322/firebase-tutorial-getting-started-2. Verder staat er in deze view de titel van de app.

### MyGardenViewController
De volgende view (MyGardenViewController) zal bestaan uit de (nu nog lege) lijst met planten van de gebruiker. Hiervoor zal ik dezelfde Firebase tutorial gebruiken als bij de vorige view. Omdat ik alles in één view wil plaatsen ontkom ik er nu nog niet aan om de lijst niet in dezelfde view neer te zetten. Qua interface is dat wellicht niet heel mooi. Als er tijd over is zal ik dit proberen om te zetten naar een homescherm (HomeViewController) met de eerstvolgende plant in het groot en de lijst met planten als een sidebar laat zien. Hiervoor heb ik de volgende tutorial gevonden:  http://www.appcoda.com/sidebar-menu-swift/. 

### AddPlantViewController
Planten kunnen toegevoegd worden door de + button op MyGardenViewController. Dit staat in een nieuwe view genaamd AddPlantViewController. Hiervoor heb ik een extra class nodig voor Firebase waarin de naam, frequentie en extra info in zal komen te staan. Deze view bestaat uit een paar text fields (name en extra info), een keuze van de frequentie (aantal dagen) en de optie om een foto te maken of toe te voegen. Ik weet nog niet hoe ik binnen een app een foto kan maken en daarvoor moet ik nog een tutorial vinden. 

## Diagram Classes
![alt tag](https://github.com/barbaraboeters/barbaraboeters-project/blob/master/doc/Diagram.png)
