# Financial Peace

1. Download CSV from Google Sheets, save as `money.csv` on desktop
2. In rails console:
    ```rb
    LineItem.delete_all
    Importer.new("/Users/efatsi/Desktop/money.csv").import
    ```
3. rails server, open http://localhost:3000
