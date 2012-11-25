require 'active_record'

class Review < ActiveRecord::Base
  belongs_to :album
  scope :bnm, where(:bnm => 1)
  scope :sigauths, select('author, count(*) AS count').group('author').having('count > ?', 10)
  scope :siglabels, select('labels.name, count(*) AS count').joins(:album => :label).group('labels.name').having('count > ?', 10) 

  def self.artist_name_like(str)
    joins(:album => :artist).where("artists.name like ?", "%#{str}%")
  end

  def self.average_rating
    average(:rating).to_f.round(2)
  end

  def self.bnm_percent
    percentage(((self.bnm.count)/(self.where('year > ?', 2002).count).to_f))
  end

  def self.authors_count
    count(:group => 'author').count
  end

  def self.top_20_authors
    select('author, count(*) AS count').group('author').order('count DESC').limit(20)
  end

  def self.top_10_bnm_auths
    bnm.select('author, count(*) AS count').group('author').order('count DESC').limit(10)
  end

  def self.most_bnm_labels
    bnm.select("labels.name, count(*) AS count").joins(:album => :label).group("labels.name").order("count DESC").limit(15)
  end

  def self.most_bnm_artists
    bnm.select("artists.name, count(*) AS count").joins(:album => :artist).group("artists.name").order("count DESC").limit(25)
  end

  def self.perfect_ratings
    self.where('rating = ?', 10)
  end

  def self.zero_ratings
    self.joins(:album => :artist).where('rating = ?', 0)
  end

  def self.top_rated_labels
    siglabels.average(:rating, :order=>'average_rating DESC', :limit=>50)
  end

  def self.lowest_rated_labels
    siglabels.average(:rating, :order=>'average_rating ASC', :limit=>50)
  end


  private
  
    def self.percentage(stat)
      ( stat * 100).round(2)
    end

end