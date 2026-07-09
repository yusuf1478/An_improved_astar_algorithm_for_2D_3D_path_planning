function [path, nodes] = rrtstar_3d(map, startnode, endnode, max_iter, step_size, goal_threshold)
    % Başlangıç değerleri
    nodes = startnode;
    parent = zeros(max_iter, 1);
    cost = inf(max_iter, 1);
    cost(1) = 0;
    
    % Debug değişkenleri
    n_collision = 0;
    n_valid = 0;
    
    goal_reached = false;
    path = [];
    min_dist_to_goal = inf;
    stall_counter = 0;
    
    % Dinamik hedef yönlendirme oranı
    goal_bias = 0.2;
    
    for k = 1:max_iter
        % Hedef yönlendirme oranını dinamik olarak ayarla
        if min_dist_to_goal > 10
            goal_bias = 0.4;  % Hedefe uzakken daha agresif yönlendirme
        else
            goal_bias = 0.2;  % Hedefe yakınken daha az yönlendirme
        end
        
        % 1. Örnekleme stratejisi
        if rand < goal_bias
            % Hedef civarında örnekleme
            noise = randn(1, 3) * step_size * 0.5;
            rand_point = endnode + noise;
        else
            % Uniform örnekleme ile birlikte Gaussian örnekleme
            if rand < 0.5
                rand_point = rand(1, 3) * 30;
            else
                % Mevcut düğümlerden birinin etrafında Gaussian örnekleme
                random_node_idx = randi(size(nodes, 1));
                rand_point = nodes(random_node_idx, :) + randn(1, 3) * step_size * 2;
            end
        end
        
        % Sınırlar içinde tut
        rand_point = max(min(rand_point, 30), 0);
        
        % 2. En yakın düğümü bul
        [nearest_idx, nearest_dist] = nearest_node(nodes, rand_point);
        nearest_node_loc = nodes(nearest_idx, :);
        
        % 3. Yeni nokta oluşturma (değişken adım boyutu)
        direction = (rand_point - nearest_node_loc) / norm(rand_point - nearest_node_loc);
        actual_step = min(step_size, nearest_dist);  % Dinamik adım boyutu
        new_node_loc = nearest_node_loc + actual_step * direction;
        
        % Çarpışma kontrolü
        if check_path_collision(nearest_node_loc, new_node_loc, map)
            n_collision = n_collision + 1;
            continue;
        end
        
        % Geçerli nokta bulundu
        n_valid = n_valid + 1;
        nodes = [nodes; new_node_loc];
        new_node_idx = size(nodes, 1);
        
        % Yakın noktaları bul (dinamik yarıçap)
        search_radius = min(step_size * 3, 5 * sqrt(log(size(nodes, 1)) / size(nodes, 1)));
        near_indices = find_near(nodes, new_node_loc, search_radius);
        
        % En iyi ebeveyni bul
        min_cost = cost(nearest_idx) + norm(new_node_loc - nearest_node_loc);
        best_parent = nearest_idx;
        
        for i = 1:length(near_indices)
            near_idx = near_indices(i);
            potential_cost = cost(near_idx) + norm(new_node_loc - nodes(near_idx, :));
            
            if potential_cost < min_cost && ~check_path_collision(new_node_loc, nodes(near_idx, :), map)
                min_cost = potential_cost;
                best_parent = near_idx;
            end
        end
        
        parent(new_node_idx) = best_parent;
        cost(new_node_idx) = min_cost;
        
        % Rewiring işlemi (optimize edilmiş)
        for i = 1:length(near_indices)
            near_idx = near_indices(i);
            potential_cost = cost(new_node_idx) + norm(nodes(near_idx, :) - new_node_loc);
            
            if potential_cost < cost(near_idx) && ~check_path_collision(new_node_loc, nodes(near_idx, :), map)
                parent(near_idx) = new_node_idx;
                cost(near_idx) = potential_cost;
                
                % Alt ağacı güncelle
                update_subtree_cost(near_idx, parent, cost, nodes);
            end
        end
        
        % Hedef kontrolü ve ilerleme takibi
        dist_to_goal = norm(new_node_loc - endnode);
        min_dist_to_goal = min(min_dist_to_goal, dist_to_goal);
        
        if dist_to_goal < goal_threshold && ~check_path_collision(new_node_loc, endnode, map)
            goal_reached = true;
            fprintf('\nHEDEFE ULAŞILDI! İterasyon: %d\n', k);
            break;
        end
        
        % Durma kontrolü
        if k > 100 && abs(min_dist_to_goal - dist_to_goal) < 0.01
            stall_counter = stall_counter + 1;
            if stall_counter > 100
                fprintf('İlerleme durdu, yeni strateji deneniyor...\n');
                goal_bias = 0.6;  % Hedef yönlendirmesini artır
                stall_counter = 0;
            end
        else
            stall_counter = 0;
        end
    end
    
    % Yol oluşturma
    if goal_reached
        current_node = new_node_idx;
        while current_node > 0
            path = [nodes(current_node, :); path];
            current_node = parent(current_node);
        end
        
        % Yol optimizasyonu
        path = optimize_path(path, map);
        
        % Final istatistikleri
        fprintf('Toplam düğüm sayısı: %d\n', size(nodes,1));
        fprintf('Çarpışma sayısı: %d\n', n_collision);
        fprintf('Geçerli nokta sayısı: %d\n', n_valid);
        fprintf('Yol uzunluğu: %.2f\n', sum(vecnorm(diff(path),2,2)));
    else
        fprintf('Hedef bulunamadı!\n');
    end
end

function update_subtree_cost(node_idx, parent, cost, nodes)
    % Alt ağaçtaki tüm düğümlerin maliyetlerini güncelle
    children = find(parent == node_idx);
    for child = children'
        old_cost = cost(child);
        new_cost = cost(node_idx) + norm(nodes(child,:) - nodes(node_idx,:));
        if new_cost < old_cost
            cost(child) = new_cost;
            update_subtree_cost(child, parent, cost, nodes);
        end
    end
end

function path = optimize_path(path, map)
    % Yolu optimize et (köşeleri yumuşat)
    i = 1;
    while i < size(path,1)-1
        if ~check_path_collision(path(i,:), path(i+2,:), map)
            path(i+1,:) = [];
        else
            i = i + 1;
        end
    end
end

% Diğer yardımcı fonksiyonlar aynı kalıyor...
% En yakın düğümü bulan fonksiyon
function [nearest_idx, nearest_dist] = nearest_node(nodes, rand_point)
    dists = vecnorm(nodes - rand_point, 2, 2); % Düğümlere olan uzaklıkları hesapla
    [nearest_dist, nearest_idx] = min(dists); % En yakın düğümü bul
end

% Yakın düğümleri bulan fonksiyon
function near_indices = find_near(nodes, new_node_loc, step_size)
    dists = vecnorm(nodes - new_node_loc, 2, 2); % Düğümlere olan uzaklıkları hesapla
    near_indices = find(dists < step_size * 2); % Yakın düğümleri bul (step_size'ı arttırarak yakındaki düğümleri bulmak için)
end

% Yol çarpışma kontrolü
function is_collision = check_path_collision(point1, point2, map, num_checks)
    if nargin < 4
        num_checks = 10; % Varsayılan kontrol noktası sayısı
    end
    
    % İki nokta arasındaki yolu num_checks kadar noktada kontrol et
    for i = 0:num_checks
        t = i / num_checks;
        % İki nokta arasında lineer interpolasyon
        check_point = point1 + t * (point2 - point1);
        
        % Bu noktada çarpışma var mı?
        if check_collision(check_point, map)
            is_collision = true;
            return;
        end
    end
    is_collision = false;
end

% Nokta çarpışma kontrolü (mevcut fonksiyonunuz)
function is_collision = check_collision(point, map)
    is_collision = false;
    Npoly = length(map.pgStart);

    for i = 1:Npoly
        % Engel bilgilerini al
        x1 = map.pgStart{i}(1);
        y1 = map.pgStart{i}(2);
        z1 = map.pgStart{i}(3);
        sizeX = map.pgBoyut{i}(1);
        sizeY = map.pgBoyut{i}(2);
        sizeZ = map.pgBoyut{i}(3);
        
        % Küpün diğer köşesinin koordinatları
        x2 = x1 + sizeX;
        y2 = y1 + sizeY;
        z2 = z1 + sizeZ;
        
        % Çarpışma kontrolü
        if point(1) >= x1 && point(1) <= x2 && ...
           point(2) >= y1 && point(2) <= y2 && ...
           point(3) >= z1 && point(3) <= z2
            is_collision = true;
            return;
        end
    end
end