FROM node:20-slim

WORKDIR /app

# Install dependencies first (cache layer)
COPY package.json ./
RUN npm install --legacy-peer-deps --include=dev

# Copy project files
COPY . .

EXPOSE 3000

# Run sources (pulls data from DuckDB/Nessie) then start dev server
CMD ["sh", "-c", "npm run sources && npm run dev"]
