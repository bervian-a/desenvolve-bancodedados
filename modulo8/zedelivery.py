from flask import Flask, request, jsonify
import sqlite3

from shapely.geometry import shape, Point
import json

app = Flask(__name__)

# Função para conectar ao banco de dados SQLite
def connect_db():
    return sqlite3.connect('parceiros.db')

# Criando a tabela de parceiros no banco de dados (caso ainda não exista)
def criar_tabela():
    conn = connect_db()
    cursor = conn.cursor()
    cursor.execute('''
    CREATE TABLE IF NOT EXISTS parceiros (
        id TEXT PRIMARY KEY,
        nome_fantasia TEXT NOT NULL,
        nome_proprietario TEXT NOT NULL,
        cnpj TEXT NOT NULL UNIQUE,
        endereco TEXT NOT NULL,
        area_cobertura TEXT NOT NULL
    );
    ''')
    conn.commit()
    conn.close()

# Inicializa a tabela assim que a aplicação iniciar
criar_tabela()

# Rota para criar um parceiro
@app.route('/parceiros', methods=['POST'])
def criar_parceiro():
    data = request.get_json()  # Pega os dados enviados no corpo da requisição
    id = data.get('id')
    nome_fantasia = data.get('nomeFantasia')
    nome_proprietario = data.get('nomeProprietario')
    cnpj = data.get('cnpj')
    endereco = data.get('endereco')
    area_cobertura = data.get('areaCobertura')
    
    # Conectar ao banco e inserir o parceiro
    conn = connect_db()
    cursor = conn.cursor()
    cursor.execute('''
    INSERT INTO parceiros (id, nome_fantasia, nome_proprietario, cnpj, endereco, area_cobertura)
    VALUES (?, ?, ?, ?, ?, ?)
    ''', (id, nome_fantasia, nome_proprietario, cnpj, endereco, area_cobertura))
    
    conn.commit()
    conn.close()

    return jsonify({'message': 'Parceiro criado com sucesso!'}), 201

# Rota para buscar um parceiro por ID
@app.route('/parceiros/<id>', methods=['GET'])
def carregar_parceiro_por_id(id):
    conn = connect_db()
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM parceiros WHERE id = ?', (id,))
    parceiro = cursor.fetchone()
    
    if parceiro:
        # Retorna os dados do parceiro em formato JSON
        return jsonify({
            'id': parceiro[0],
            'nomeFantasia': parceiro[1],
            'nomeProprietario': parceiro[2],
            'cnpj': parceiro[3],
            'endereco': parceiro[4],
            'areaCobertura': parceiro[5]
        })
    else:
        return jsonify({'message': 'Parceiro não encontrado'}), 404

# Rodando o servidor
if __name__ == '__main__':
    app.run(debug=True)


##Encontrar parceriro

@app.route('/parceiros/proximo', methods=['GET'])
def parceiro_proximo():
    # Pega coordenadas da URL: ?lon=-46.57421&lat=-21.785741
    lon = float(request.args.get('lon'))
    lat = float(request.args.get('lat'))
    ponto = Point(lon, lat)

    conn = connect_db()
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM parceiros')
    parceiros = cursor.fetchall()
    conn.close()

    parceiro_mais_proximo = None
    menor_distancia = float('inf')

    for p in parceiros:
        id, trading_name, owner_name, document, address_str, coverage_str = p
        
        address = json.loads(address_str)
        coverage = json.loads(coverage_str)

        area = shape(coverage)  # transforma em MultiPolygon

        if area.contains(ponto):
            endereco_coords = address['coordinates']
            endereco_point = Point(endereco_coords[0], endereco_coords[1])
            distancia = ponto.distance(endereco_point)

            if distancia < menor_distancia:
                menor_distancia = distancia
                parceiro_mais_proximo = {
                    'id': id,
                    'tradingName': trading_name,
                    'ownerName': owner_name,
                    'document': document,
                    'address': address,
                    'coverageArea': coverage
                }

    if parceiro_mais_proximo:
        return jsonify(parceiro_mais_proximo)
    else:
        return jsonify({'message': 'Nenhum parceiro encontrado na cobertura informada.'}), 404
